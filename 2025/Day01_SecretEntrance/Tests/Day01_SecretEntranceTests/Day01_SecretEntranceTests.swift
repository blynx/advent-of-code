import Testing
import Foundation
@testable import Day01_SecretEntrance

@Suite struct SecretEntranceTests {
	let inputRotations: [(direction: SecretEntrance.Direction, clicks: Int)]
	let inputSmallRotations: [(direction: SecretEntrance.Direction, clicks: Int)]
	
	init() {
		let rawInputRotations = String(decoding: Data(PackageResources.Input_txt), as: UTF8.self)
		inputRotations = try! SecretEntrance.parse(rawInput: rawInputRotations)
		let rawInputSmallRotations = String(decoding: Data(PackageResources.InputSmall_txt), as: UTF8.self)
		inputSmallRotations = try! SecretEntrance.parse(rawInput: rawInputSmallRotations)
	}

	@Test func inputSmallTest() {
		let secretEntrance = SecretEntrance()
		let (code, code_0x434C49434B) = secretEntrance.dial(rotationInstructions: inputSmallRotations)
		#expect(code == 3)
		#expect(code_0x434C49434B == 6)
	}
	
	@Test func inputTest() {
		let secretEntrance = SecretEntrance()
		let (code, code_0x434C49434B) = secretEntrance.dial(rotationInstructions: inputRotations)
		#expect(code == 1154)
		#expect(code_0x434C49434B == 6819)
	}
	
	@Test func rotateMultipleTurnsLeftWithAdditionalZeroSwipeTest() {
		let secretEntrance = SecretEntrance()
		let (position, zeroSwipes) = secretEntrance.rotate(from: 10, towards: .Left, by: 250)
		#expect(position == 60)
		#expect(zeroSwipes == 3)
	}
	
	@Test func rotateMultipleTurnsLeftWithoutAdditionalZeroSwipeTest() {
		let secretEntrance = SecretEntrance()
		let (position, zeroSwipes) = secretEntrance.rotate(from: 10, towards: .Left, by: 205)
		#expect(position == 5)
		#expect(zeroSwipes == 2)
	}
	
	@Test func rotateMultipleTurnsRightWithAdditionalZeroSwipeTest() {
		let secretEntrance = SecretEntrance()
		let (position, zeroSwipes) = secretEntrance.rotate(from: 95, towards: .Right, by: 210)
		#expect(position == 5)
		#expect(zeroSwipes == 3)
	}
	
	@Test func rotateMultipleTurnsRightOntoZeroTest() {
		let secretEntrance = SecretEntrance()
		let (position, zeroSwipes) = secretEntrance.rotate(from: 95, towards: .Right, by: 205)
		#expect(position == 0)
		#expect(zeroSwipes == 2)
	}
	
	@Test func rotateMultipleTurnsLeftOntoZeroTest() {
		let secretEntrance = SecretEntrance()
		let (position, zeroSwipes) = secretEntrance.rotate(from: 5, towards: .Left, by: 205)
		#expect(position == 0)
		#expect(zeroSwipes == 2)
	}
}

