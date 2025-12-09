import Foundation

struct Lobby {
	static func parse(rawInput: String) -> [String] {
		return rawInput.split(separator: "\n").map(String.init)
	}
	
	func turnOnEscalator(banks: [String], numOfBatteries: Int) -> [Int] {
		return banks.map { bank in chooseBatteries(numOfBatteries, inBank: bank) }
	}
	
	@available(*, deprecated)
	func chooseTwoBatteries(inBank bank: String) -> Int {
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
	
	func chooseBatteries(_ numOfBatteries: Int, inBank bank: String) -> Int {
		let chosenBatteryList = chooseBatteries(numOfBatteries, inBank: Array(bank)[...], into: [Character]())
		return Int(String(chosenBatteryList))!
	}
	
	func chooseBatteries(_ numOfBatteries: Int, inBank bank: ArraySlice<Character>, into chosenBatteries: [Character]) -> [Character] {
		guard numOfBatteries > 0 else { return chosenBatteries }
		let endIndex = bank.endIndex.advanced(by: -numOfBatteries)
		let (maxBattery, maxBatteryIndex) = bank[...endIndex].maxWithIndex()
		return chooseBatteries(numOfBatteries - 1,
							   inBank: bank[maxBatteryIndex!.advanced(by: 1)...],
							   into: chosenBatteries + [maxBattery!])
	}
}

extension Collection where Element: Comparable {
	func maxWithIndex() -> (item: Element?, index: Index?) {
		if let index = self.indices.max(by: { self[$1] > self[$0] }) {
			return (self[index], index)
		}
		return (nil, nil)
	}
}
