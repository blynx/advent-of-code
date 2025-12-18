public struct Location: Hashable, Equatable {
    let x: Int
    let y: Int
    
    public init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    public init(v: Vector) {
        self.x = v.0
        self.y = v.1
    }
    
    public var vector: Vector {
        (x, y)
    }
    
    public var neighbors: Set<Location> {
        Set(Direction.allCases.map { self + $0.value })
    }
}

extension Location: CustomStringConvertible {
    public var description: String {
        "(\(x), \(y))"
    }
}

public func + (left: Location, right: Vector) -> Location {
    Location(left.x + right.x, left.y + right.y)
}

public func + (left: Vector, right: Location) -> Location {
    Location(left.x + right.x, left.y + right.y)
}

public func - (left: Location, right: Vector) -> Location {
    Location(left.x - right.x, left.y - right.y)
}
