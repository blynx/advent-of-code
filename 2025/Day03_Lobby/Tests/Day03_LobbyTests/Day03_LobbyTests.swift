import Testing
import Foundation
@testable import Day03_Lobby

@Suite struct LobbyTests {
	let input: [String]
	
	init() {
		let rawInput = String(decoding: Data(PackageResources.Input_txt), as: UTF8.self)
		input = Lobby.parse(rawInput: rawInput)
	}

	@Test func chooseBatteryTest() {
		let lobby = Lobby()
		#expect(lobby.chooseBatteries(inBank: "987654321111111") == 98)
		#expect(lobby.chooseBatteries(inBank: "811111111111119") == 89)
		#expect(lobby.chooseBatteries(inBank: "234234234234278") == 78)
		#expect(lobby.chooseBatteries(inBank: "818181911112111") == 92)
	}
	
	@Test("Part 1: Turn on escalator")
	func turnOnEscalatorTest() {
		let lobby = Lobby()
		let banks = lobby.turnOnEscalator(banks: input)
		#expect(banks.sum == 17445)
	}
}

extension Array where Element == Int {
	var sum: Int {
		self.reduce(0, +)
	}
}

