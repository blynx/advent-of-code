import Foundation

struct Lobby {
	static func parse(rawInput: String) -> [String] {
		return rawInput.split(separator: "\n").map(String.init)
	}
	
	func turnOnEscalator(banks: [String]) -> [Int] {
		return banks.map(chooseBatteries(inBank:))
	}
	
	func chooseBatteries(inBank bank: String) -> Int {
		var tensBattery: Character = "0"
		var onesBattery: Character = "0"
		for index in bank.indices.dropLast(1) {
			let currentBattery: Character = bank[index]
			if (currentBattery > tensBattery) {
				tensBattery = currentBattery
				onesBattery = "0"
			} else if (currentBattery > onesBattery) {
				onesBattery = currentBattery
			}
		}
		let lastBattery = bank.last!
		if lastBattery > onesBattery {
			onesBattery = lastBattery
		}
		return tensBattery.wholeNumberValue! * 10 + onesBattery.wholeNumberValue!
	}
}
