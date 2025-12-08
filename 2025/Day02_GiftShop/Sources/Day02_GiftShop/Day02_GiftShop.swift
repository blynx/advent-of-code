import Foundation

struct GiftShop {
	typealias ProductIdRanges = [ClosedRange<Int>]
	
	enum SillyIdCriteria {
		case Simple
		case AdvancedStringAlgo
		case AdvancedNumericAlgo
		
		func testIdIsSimple(_ id: Int) -> Bool {
			switch self {
			case .Simple: return GiftShop.isSillyIdSimple(id)
			case .AdvancedStringAlgo: return GiftShop.isSillyIdAdvancedStringAlgo(id)
			case .AdvancedNumericAlgo: return GiftShop.isSillyIdAdvancedNumericAlgo(id)
			}
		}
	}
	
	static func parse(_ rawInput: String) -> ProductIdRanges {
		return rawInput.replacing(/\s/, with: "").split(separator: ",").map { range in
			let rangeLimits = range.split(separator: "-")
			let rangeStart = Int(rangeLimits.first!)!
			let rangeEnd = Int(rangeLimits.last!)!
			return rangeStart...rangeEnd
		}
	}
	
	func findSillyIds(in productIdRanges: ProductIdRanges, _ sillyIdCriteria: SillyIdCriteria) -> [Int] {
		var sillyIds: [Int] = []
		productIdRanges.forEach { productIdRange in
			productIdRange.forEach { productId in
				if sillyIdCriteria.testIdIsSimple(productId) {
					sillyIds.append(productId)
				}
			}
		}
		return sillyIds
	}
	
	static func isSillyIdSimple(_ id: Int) -> Bool {
		let digitCount = id.digitCount()
		guard digitCount > 1 else { return false }
		guard digitCount.isMultiple(of: 2) else { return false }
		
		let halfDigitCount = digitCount / 2
		let (leftPart, rightPart) = id.split(fromRight: halfDigitCount)
		
		if(leftPart == rightPart) {
			return true
		}
		return false
	}
	
	static func isSillyIdAdvancedStringAlgo(_ id: Int) -> Bool {
		guard id > 10 else { return false }
		let idString = String(id)
		
		var chunkSize = 1
		while chunkSize <= idString.count / 2 {
			if (idString.count.isMultiple(of: chunkSize)) {
				let chunks = stride(from: 0, to: idString.count, by: chunkSize).map { index in
					let start = idString.index(idString.startIndex, offsetBy: index)
					let end = idString.index(start, offsetBy: chunkSize)
					return String(idString[start..<end])
				}
				if (chunks.allSatisfy({ $0 == chunks.first })) {
					return true
				}
			}
			chunkSize += 1
		}
		return false
	}
	
	static func isSillyIdAdvancedNumericAlgo(_ id: Int) -> Bool {
		guard id > 10 else { return false }
		let digitCount = id.digitCount()
		var chunkSize = 1
		while chunkSize <= digitCount / 2 {
			if (digitCount % chunkSize == 0) {
				var chunkIndex = 1
				var (leftPart, chunk) = id.split(fromRight: chunkSize)
				var probeIsSilly = true
				while chunkIndex < (digitCount / chunkSize) {
					let (newLeftPart, newChunk) = leftPart.split(fromRight: chunkSize)
					if (newChunk != chunk) {
						probeIsSilly = false
						break
					}
					leftPart = newLeftPart
					chunk = newChunk
					chunkIndex += 1
				}
				if (probeIsSilly == true) {
					return true
				}
			}
			chunkSize += 1
		}
		return false
	}
}

extension Int {
	func digitCount() -> Int {
		if self == 0 { return 1 }
		var n = abs(self)
		var count = 0
		while n > 0 {
			n /= 10
			count += 1
		}
		return count
	}
	
	func split(fromRight decimalPlaces: Int) -> (left: Int, right: Int) {
		let divisor = Int(pow(10.0, Double(decimalPlaces)))
		let left = self / divisor
		let right = self % divisor
		return (left, right)
	}
}
