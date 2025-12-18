import Testing
import Foundation
import SwiftGrid
@testable import Day04_PrintingDepartment

@Suite struct PrintingDepartmentTests {
    let input: String
    let smallInput = """
					..@@.@@@@.
					@@@.@.@.@@
					@@@@@.@.@@
					@.@@@@..@.
					@@.@@@@.@@
					.@@@@@@@.@
					.@.@.@.@@@
					@.@@@.@@@@
					.@@@@@@@@.
					@.@.@@@.@.
					"""

	init() {
		input = String(decoding: Data(PackageResources.Input_txt), as: UTF8.self)
	}

	@Test func part1SmallTest() throws {
		let grid = try Grid<Character>.from(multiLineString: smallInput)
		#expect(PrintingDepartment.accessibleRollsOfPaper(in: grid) == 13)
	}

	@Test("Part 1: Number of accessible paper rolls")
	func part1Test() throws {
    	let grid = try Grid<Character>.from(multiLineString: input)
    	#expect(PrintingDepartment.accessibleRollsOfPaper(in: grid) == 1344)
	}

	@Test func part2SmallTest() throws {
       	let grid = try Grid<Character>.from(multiLineString: smallInput)
       	#expect(PrintingDepartment.removeRollsOfPaper(in: grid) == 43)
	}

	@Test("Part 2: Number of removed rolls of paper")
    	func part2Test() throws {
       	let grid = try Grid<Character>.from(multiLineString: input)
       	#expect(PrintingDepartment.removeRollsOfPaper(in: grid) == 8112)
	}
}
