import Testing
import Foundation
@testable import Day05_Cafeteria

@Suite struct CafeteriaTests {
    let input: (freshIdRanges: [ClosedRange<Int>], ingredientIds: Set<Int>)
    let smallInput = 
    """
    3-5
    10-14
    16-20
    12-18
    
    1
    5
    8
    11
    17
    32
    
    """
    
    init() {
    	let rawInput = String(decoding: Data(PackageResources.Input_txt), as: UTF8.self)
        input = Cafeteria.parse(rawInput)
    }

    @Test func ClosedRangeExtensionFromTest() {
        let range = ClosedRange.from(string: "20-350")!
        #expect(range == (20...350))
    }
    
    @Test func parseTest() {
        let (freshIdRanges, ingredientIds) = Cafeteria.parse(smallInput)
        #expect(freshIdRanges == Array([(3...5), (10...20)]))
        #expect(ingredientIds == Set([17, 5, 11, 1, 8, 32]))
    }

    @Test func part1SmallTest() {
        let (freshIdRanges, ingredientIds) = Cafeteria.parse(smallInput)
        let freshIngredientIds = Cafeteria.findFresh(ingredientIds, in: freshIdRanges)
        #expect(freshIngredientIds.count == 3)
    }
    
    @Test("Part 1: Find fresh ingredients")
    func part1Test() {
        let (freshIdRanges, ingredientIds) = input
        let freshIngredientIds = Cafeteria.findFresh(ingredientIds, in: freshIdRanges)
        #expect(freshIngredientIds.count == 744)
    }
    
    @Test("Part 2: Count all ids considered fresh")
    func part2Test() {
        let (freshIdRanges, _) = input
        let freshTotal = freshIdRanges.reduce(into: 0) { sum, range in sum += range.count }
        #expect(freshTotal == 347468726696961)
    }
}
