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
		#expect(lobby.chooseTwoBatteries(inBank: "987654321111111") == 98)
		#expect(lobby.chooseTwoBatteries(inBank: "811111111111119") == 89)
		#expect(lobby.chooseTwoBatteries(inBank: "234234234234278") == 78)
		#expect(lobby.chooseTwoBatteries(inBank: "818181911112111") == 92)
	}
	
	@Test("Part 1: Turn on escalator")
	func turnOnEscalatorTest() {
		let lobby = Lobby()
		let banks = lobby.turnOnEscalator(banks: input, numOfBatteries: 2)
		#expect(banks.sum == 17445)
	}
	
	@Test("Part 2: Turn on escalator with 12 batteries")
	func turnOnEscalatorProperlyTest() {
		let lobby = Lobby()
		let banks = lobby.turnOnEscalator(banks: input, numOfBatteries: 12)
		#expect(banks.sum == 173229689350551)
	}
	
	@Test func chooseBatteriesTest() {
		let lobby = Lobby()

		#expect(lobby.chooseBatteries(1, inBank: "2413") == 4)
		#expect(lobby.chooseBatteries(2, inBank: "818181911112111") == 92)
		
		#expect(lobby.chooseBatteries(12, inBank: "987654321111111") == 987654321111)
		#expect(lobby.chooseBatteries(12, inBank: "811111111111119") == 811111111119)
		#expect(lobby.chooseBatteries(12, inBank: "234234234234278") == 434234234278)
		#expect(lobby.chooseBatteries(12, inBank: "818181911112111") == 888911112111)
		
	}
}

extension Array where Element == Int {
	var sum: Int {
		self.reduce(0, +)
	}
}

