import Foundation

struct SecretEntrance {
	static let dialSize: Int = 100
	
	typealias RotationInstructions = [(direction: Direction, clicks: Int)]
	
	enum DialError : Error {
		case ImpossibleRotationDirection
	}
	
	enum Direction: Int {
		case Left = -1
		case Right = 1
	}
	
	static func parse(rawInput: String) throws -> RotationInstructions {
		try rawInput.split(separator: "\n").map { rawRotation in
			let direction = switch rawRotation[rawRotation.startIndex] {
				case "L": Direction.Left
				case "R": Direction.Right
				default: throw DialError.ImpossibleRotationDirection
			}
			let clicks: Int = Int(rawRotation[rawRotation.index(rawRotation.startIndex, offsetBy: 1)...])!
			return (direction, clicks)
		}
	}
	
	func dial(rotationInstructions: RotationInstructions) -> (code: Int, code_0x434C49434B: Int) {
		var position = 50
		var code: Int = 0
		var code_0x434C49434B: Int = 0
		for (direction, clicks) in rotationInstructions {
			let (newPosition, zeroSwipes) = rotate(from: position, towards: direction, by: clicks)
			position = newPosition
			if position == 0 {
				code += 1
				code_0x434C49434B += 1
			}
			code_0x434C49434B += zeroSwipes
		}
		return (code, code_0x434C49434B)
	}
	
	internal func rotate(from startPosition: Int, towards direction: Direction, by clicks: Int) -> (endPosition: Int, zeroSwipes: Int) {
		let (fullTurns, remainingClicks) = clicks.quotientAndRemainder(dividingBy: SecretEntrance.dialSize)
		let endPosition = mod(input: startPosition + (direction.rawValue * remainingClicks), modulus: SecretEntrance.dialSize)
		let additionalZeroSwipe = startPosition != 0 && endPosition != 0
			&& ((endPosition - startPosition) * direction.rawValue < 0) ? 1 : 0
		return (endPosition, fullTurns + additionalZeroSwipe)
	}
	
	/// Mathematical modulo, in contrast to the symmetric modulo as used in Swift.
	/// https://stackoverflow.com/questions/25726760/javascript-modular-arithmetic
	private func mod(input: Int, modulus: Int) -> Int {
		return ((input % modulus) + modulus) % modulus
	}
}

