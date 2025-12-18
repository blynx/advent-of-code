public typealias Vector = (x: Int, y: Int)

public func + (left: Vector, right: Vector) -> Vector {
    (left.0 + right.0, left.1 + right.1)
}

public func - (left: Vector, right: Vector) -> Vector {
    (left.0 - right.0, left.1 - right.1)
}

public func * (left: Vector, right: Int) -> Vector {
    (left.0 * right, left.1 * right)
}

public func * (left: Int, right: Vector) -> Vector {
    (left * right.0, left * right.0)
}

public enum Direction: CaseIterable {
    case north, northEast, east, southEast, south, southWest, west, northWest

    var value: Vector {
        return switch self {
        case .north: Vector(0, -1)
        case .northEast: Vector(1, -1)
        case .east: Vector(1, 0)
        case .southEast: Vector(1, 1)
        case .south: Vector(0, 1)
        case .southWest: Vector(-1, 1)
        case .west: Vector(-1, 0)
        case .northWest: Vector(-1, -1)
        }
    }
}
