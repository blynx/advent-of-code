import Foundation

struct Cafeteria {
    static func parse(_ input: String) -> (freshIdRanges: [ClosedRange<Int>], ingredientIds: Set<Int>) {
        let parts = input.split(separator: "\n\n")
        let rawFreshIdRanges = parts[0].split(separator: "\n")
        let freshIdRanges = rawFreshIdRanges.compactMap({ ClosedRange.from(string: $0)! }).condense()
        let ingredientIds = Set(parts[1].split(separator: "\n").map({ Int($0)! }))
        return (freshIdRanges, ingredientIds)
    }
    
	static func findFresh(_ ingredientIds: Set<Int>, in freshIdRanges: [ClosedRange<Int>]) -> Set<Int> {
	    ingredientIds.filter({ id in freshIdRanges.first(where: { $0.contains(id) }) != nil })
	}
}

extension ClosedRange where Element == Int {
    static func from(string: some StringProtocol) -> ClosedRange? {
        let bounds = string.split(separator: "-")
        if bounds.count == 2 {
            return (Element(bounds[0])!...Element(bounds[1])!)
        }
        return nil
    }
    
    func union(with other: ClosedRange) -> ClosedRange {
        (Swift.min(self.lowerBound, other.lowerBound)...(Swift.max(self.upperBound, other.upperBound)))
    }
}

extension Array where Element == ClosedRange<Int> {
    func condense() -> Array<Element> {
        self.sorted(by: { $0.lowerBound < $1.lowerBound })
            .reduce(into: Array<ClosedRange<Int>>()) { mergedRanges, currentRange in 
                if let lastMergedRange = mergedRanges.last, lastMergedRange.overlaps(currentRange) {
                    mergedRanges[mergedRanges.endIndex - 1] = lastMergedRange.union(with: currentRange)
                } else {
                    mergedRanges.append(currentRange)
                }
            }
    }
}
