#!/usr/bin/env swift

import Foundation

enum TemplateProcessorError: Error, CustomStringConvertible {
    case incorrectArguments
    case sourceFolderNotFound(String)
    case targetLocationNotFound(String)
    case noValidReplacements(String)
    case copyFailed(Error)

    var description: String {
        switch self {
        case .incorrectArguments:
            return "Error: Incorrect number of arguments"
        case .sourceFolderNotFound(let path):
            return "Error: Source folder '\(path)' does not exist"
        case .targetLocationNotFound(let path):
            return "Error: Target location '\(path)' does not exist"
        case .noValidReplacements(let input):
            return "Error: No valid replacement pairs found in '\(input)'"
        case .copyFailed(let error):
            return "Error copying folder: \(error)"
        }
    }
}

struct ReplacementPair {
    let from: String
    let to: String
}

struct TemplateProcessor {
    private let fileManager = FileManager.default

    static func main() {
        let processor = TemplateProcessor()
        do {
            try processor.run()
        } catch {
            print(error)
            if error is TemplateProcessorError {
                processor.printUsage()
            }
            exit(1)
        }
    }

    func run() throws {
        let args = Array(CommandLine.arguments.dropFirst())
        let (sourceFolder, replacements, targetLocation) = try validateArgs(args)
        try validatePaths(sourceFolder: sourceFolder, targetLocation: targetLocation)
        let replacementPairs = try parseReplacements(replacements)
        try processTemplate(
            sourceFolder: sourceFolder,
            replacementPairs: replacementPairs,
            targetLocation: targetLocation
        )
    }

    private func validateArgs(_ args: [String]) throws -> (String, String, String) {
        guard args.count >= 3 else {
            throw TemplateProcessorError.incorrectArguments
        }
        return (args[0], args[1], args[2])
    }

    private func validatePaths(sourceFolder: String, targetLocation: String) throws {
        guard fileManager.fileExists(atPath: sourceFolder) else {
            throw TemplateProcessorError.sourceFolderNotFound(sourceFolder)
        }

        guard fileManager.fileExists(atPath: targetLocation) else {
            throw TemplateProcessorError.targetLocationNotFound(targetLocation)
        }
    }

    private func parseReplacements(_ replacementsStr: String) throws -> [ReplacementPair] {
        let pairs = replacementsStr.components(separatedBy: " ")
            .filter { $0.contains(",") }
            .compactMap { pair -> ReplacementPair? in
                let components = pair.components(separatedBy: ",")
                guard !components.isEmpty else { return nil }
                let from = components[0]
                let to = components.count > 1 ? components[1] : ""
                return ReplacementPair(from: from, to: to)
            }

        guard !pairs.isEmpty else {
            throw TemplateProcessorError.noValidReplacements(replacementsStr)
        }

        return pairs
    }

    private func processTemplate(
        sourceFolder: String,
        replacementPairs: [ReplacementPair],
        targetLocation: String
    ) throws {
        let newFolderName = replacementPairs.reduce(URL(fileURLWithPath: sourceFolder).lastPathComponent) { result, pair in
            result.replacingOccurrences(of: pair.from, with: pair.to)
        }

        let targetURL = URL(fileURLWithPath: targetLocation).appendingPathComponent(newFolderName)
        let targetPath = targetURL.path

        do {
            try fileManager.copyItem(atPath: sourceFolder, toPath: targetPath)
        } catch {
            throw TemplateProcessorError.copyFailed(error)
        }

        replacementPairs.forEach { pair in
            applyReplacementsToDirectories(targetPath, pair)
        }

        replacementPairs.forEach { pair in
            applyReplacementsToFilenames(targetPath, pair)
        }

        replacementPairs.forEach { pair in
            applyReplacementsToContents(targetPath, pair)
        }

        printSuccessMessage(sourceFolder: sourceFolder, targetPath: targetPath, replacementPairs: replacementPairs)
    }

    private func applyReplacementsToDirectories(_ targetPath: String, _ pair: ReplacementPair) {
        let targetURL = URL(fileURLWithPath: targetPath)

        guard let enumerator = fileManager.enumerator(
            at: targetURL,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        ) else { return }

        let directories = enumerator.compactMap { element -> URL? in
            guard let url = element as? URL else { return nil }

            do {
                let resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey])
                if resourceValues.isDirectory == true && url.lastPathComponent.contains(pair.from) {
                    return url
                }
            } catch {
                // Skip if we can't get resource values
            }

            return nil
        }

        // Sort directories by depth (deepest first) to avoid path issues
        let sortedDirectories = directories.sorted { url1, url2 in
            url1.pathComponents.count > url2.pathComponents.count
        }

        for directory in sortedDirectories {
            let newPath = directory.path.replacingOccurrences(of: pair.from, with: pair.to)
            guard directory.path != newPath else { continue }

            do {
                try fileManager.moveItem(atPath: directory.path, toPath: newPath)
            } catch {
                print("Error renaming directory: \(error)")
            }
        }
    }

    private func applyReplacementsToFilenames(_ targetPath: String, _ pair: ReplacementPair) {
        let targetURL = URL(fileURLWithPath: targetPath)

        guard let enumerator = fileManager.enumerator(
            at: targetURL,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        ) else { return }

        let files = enumerator.compactMap { element -> URL? in
            guard let url = element as? URL else { return nil }

            do {
                let resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey])
                if resourceValues.isDirectory != true && url.lastPathComponent.contains(pair.from) {
                    return url
                }
            } catch {
                // Skip if we can't get resource values
            }

            return nil
        }

        for file in files {
            let newPath = file.path.replacingOccurrences(of: pair.from, with: pair.to)
            guard file.path != newPath else { continue }

            do {
                try fileManager.moveItem(atPath: file.path, toPath: newPath)
            } catch {
                print("Error renaming file: \(error)")
            }
        }
    }

    private func applyReplacementsToContents(_ targetPath: String, _ pair: ReplacementPair) {
        let targetURL = URL(fileURLWithPath: targetPath)

        guard let enumerator = fileManager.enumerator(
            at: targetURL,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        ) else { return }

        enumerator.forEach { element in
            guard let url = element as? URL else { return }

            do {
                let resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey])
                guard resourceValues.isDirectory != true else { return }

                let content = try String(contentsOf: url, encoding: .utf8)
                let updatedContent = content.replacingOccurrences(of: pair.from, with: pair.to)
                try updatedContent.write(to: url, atomically: true, encoding: .utf8)
            } catch {
                // Skip binary files or files that can't be read as text
            }
        }
    }

    private func printUsage() {
        print("Usage: swift script.swift <source_folder> <replacements> <target_location>")
        print("Example: swift script.swift template_folder 'OLD_NAME,NEW_NAME FOO,BAR' .")
        print("Replacements format: 'FROM1,TO1 FROM2,TO2 FROM3,TO3'")
    }

    private func printSuccessMessage(
        sourceFolder: String,
        targetPath: String,
        replacementPairs: [ReplacementPair]
    ) {
        print("Successfully copied '\(sourceFolder)' to '\(targetPath)' with string replacements")
        replacementPairs.forEach { pair in
            print("Replaced '\(pair.from)' with '\(pair.to)' in folder names, file names, and file contents")
        }
    }
}

// Run the main function
TemplateProcessor.main()
