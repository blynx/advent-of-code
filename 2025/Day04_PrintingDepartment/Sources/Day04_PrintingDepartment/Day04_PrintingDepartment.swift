import Foundation
import SwiftGrid

struct PrintingDepartment {
    static func accessibleRollsOfPaper(in paperGrid: Grid<Character>) -> Int {
        return paperGrid.locations.filter({ location in 
            paperGrid[location] == "@" && paperGrid[location.neighbors].count(of: "@") < 4
        }).count
    }

    static func removeRollsOfPaper(in paperGrid: Grid<Character>) -> Int {
        var cleanedUpGrid = paperGrid
        var removedRolls = 0
        var dirty = true
        while dirty {
            dirty = false
            cleanedUpGrid = cleanedUpGrid.map(withLocation: { location, element in 
                if element == "@" && cleanedUpGrid[location.neighbors].count(of: "@") < 4 {
                    cleanedUpGrid[location] = "."
                    removedRolls += 1
                    dirty = true
                }
                return cleanedUpGrid[location]
            })
        }
        return removedRolls
    }
}

extension Array {
    func count(of element: Element) -> Int where Element: Equatable {
        self.filter { $0 == element }.count
    }
}
