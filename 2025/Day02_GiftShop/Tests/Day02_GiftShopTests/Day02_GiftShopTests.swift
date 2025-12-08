import Testing
import Foundation
@testable import Day02_GiftShop

@Suite struct GiftShopTests {
	let input: GiftShop.ProductIdRanges
	let inputSmall: GiftShop.ProductIdRanges
	
	init() {
		input = GiftShop.parse(String(decoding: Data(PackageResources.Input_txt), as: UTF8.self))
		inputSmall = GiftShop.parse(String(decoding: Data(PackageResources.InputSmall_txt), as: UTF8.self))
	}
	
	@Test("Part 1: Sum of invalid IDs (small input)")
	func part1SmallTest() {
		let giftShop = GiftShop()
		let invalidIds = giftShop.findSillyIds(in: inputSmall, .Simple)
		let sum = invalidIds.reduce(0, +)
		#expect(sum == 1227775554)
	}
	
	@Test("Part 1: Sum of invalid IDs")
	func part1Test() {
		let giftShop = GiftShop()
		let invalidIds = giftShop.findSillyIds(in: input, .Simple)
		let sum = invalidIds.reduce(0, +)
		#expect(sum == 30323879646)
	}
	
	@Test("Part 2: Sum of invalid IDs, but with correct pattern. (using String algo)")
	func part2StringAlgoTest() {
		let giftShop = GiftShop()
		let clock = ContinuousClock()
		var invalidIds: [Int] = []
		let elapsed = clock.measure {
			invalidIds = giftShop.findSillyIds(in: input, .AdvancedStringAlgo)
		}
		let sum = invalidIds.reduce(0, +)
		#expect(sum == 43872163557)
		print("Advanced algo with strings measured: \(elapsed)")
	}
	
	@Test("Part 2: Sum of invalid IDs, but with correct pattern. (using Numeric algo)")
	func part2StringNumericTest() {
		let giftShop = GiftShop()
		let clock = ContinuousClock()
		var invalidIds: [Int] = []
		let elapsed = clock.measure {
			invalidIds = giftShop.findSillyIds(in: input, .AdvancedNumericAlgo)
		}
		let sum = invalidIds.reduce(0, +)
		#expect(sum == 43872163557)
		print("Advanced numeric algo measured: \(elapsed)")
	}
	
	@Test func integerDigitCountTest() {
		let two = 12.digitCount()
		let five = 12345.digitCount()
		
		#expect(two == 2)
		#expect(five == 5)
	}
	
	@Test func integerSplitTest() {
		#expect(1212.split(fromRight: 2) == (12, 12))
		#expect(1234567.split(fromRight: 3) == (1234, 567))
		#expect(123.split(fromRight: 1) == (12, 3))
	}
	
	@Test func isSillyIdSimpleTest() {
		#expect(GiftShop.isSillyIdSimple(1) == false)
		#expect(GiftShop.isSillyIdSimple(12) == false)
		#expect(GiftShop.isSillyIdSimple(123) == false)
		#expect(GiftShop.isSillyIdSimple(676) == false)
		
		#expect(GiftShop.isSillyIdSimple(22) == true)
		#expect(GiftShop.isSillyIdSimple(2323) == true)
	}
	
	@Test func isSillyIdAdvancedStringAlgoTest() {
		#expect(GiftShop.isSillyIdAdvancedStringAlgo(1) == false)
		#expect(GiftShop.isSillyIdAdvancedStringAlgo(11) == true)
		
		#expect(GiftShop.isSillyIdAdvancedStringAlgo(12) == false)
		#expect(GiftShop.isSillyIdAdvancedStringAlgo(123) == false)
		#expect(GiftShop.isSillyIdAdvancedStringAlgo(1234) == false)
		
		#expect(GiftShop.isSillyIdAdvancedStringAlgo(1212) == true)
		#expect(GiftShop.isSillyIdAdvancedStringAlgo(123123) == true)
		
		#expect(GiftShop.isSillyIdAdvancedStringAlgo(486486486) == true)
		#expect(GiftShop.isSillyIdAdvancedStringAlgo(4860486486) == false)
	}
	
	@Test func isSillyIdAdvancedNumericAlgoTest() {
		#expect(GiftShop.isSillyIdAdvancedNumericAlgo(1) == false)
		#expect(GiftShop.isSillyIdAdvancedNumericAlgo(11) == true)
		
		#expect(GiftShop.isSillyIdAdvancedNumericAlgo(12) == false)
		#expect(GiftShop.isSillyIdAdvancedNumericAlgo(123) == false)
		#expect(GiftShop.isSillyIdAdvancedNumericAlgo(1234) == false)
		
		#expect(GiftShop.isSillyIdAdvancedNumericAlgo(1212) == true)
		#expect(GiftShop.isSillyIdAdvancedNumericAlgo(123123) == true)
		
		#expect(GiftShop.isSillyIdAdvancedNumericAlgo(486486486) == true)
		#expect(GiftShop.isSillyIdAdvancedNumericAlgo(4860486486) == false)
		
		#expect(GiftShop.isSillyIdAdvancedNumericAlgo(4477477) == false)
		#expect(GiftShop.isSillyIdAdvancedNumericAlgo(4490490) == false)
		#expect(GiftShop.isSillyIdAdvancedNumericAlgo(4485485) == false)
	}
}
