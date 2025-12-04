import Testing
import Foundation
@testable import Day00_BoilerPlate

@Suite struct BoilerPlateTests {
	init() {
		let rawInput = String(decoding: Data(PackageResources.Input_txt), as: UTF8.self)
		let rawInputSmall = String(decoding: Data(PackageResources.InputSmall_txt), as: UTF8.self)
	}

	@Test func parseTest() {
		#expect(true)
	}
}
