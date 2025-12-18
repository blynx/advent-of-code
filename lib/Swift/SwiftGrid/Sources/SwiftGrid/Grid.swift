public struct Grid<Element>: RandomAccessCollection, MutableCollection {
    internal var _buffer: [Element]
    public let width: Int
    public let height: Int

    public typealias Index = Int

    enum GridError: Error {
        case initError(message: String)
    }
    
    private func _subscriptPrecondition(_ idx: Int) {
        precondition(idx >= startIndex && idx < endIndex, "Given index \"\(idx)\" out of bounds.")
    }

    private func _subscriptPrecondition(_ loc: Location) {
        _subscriptPrecondition(loc.x + (width * loc.y))
    }
    
    public init(data: Array<Element>, width w: Int, height h: Int) throws {
        guard data.count == w * h else {
            throw GridError.initError(message: "Given width and height do not match init data length.")
        }
        width = w
        height = h
        _buffer = data
    }
    
    public init(data: Array<Array<Element>>) throws {
        guard data.allSatisfy({ $0.count == data.first?.count }) else {
            throw GridError.initError(message: "Uneven lengths of rows.")
        }
        guard data.first?.count ?? 0 > 0 else {
            throw GridError.initError(message: "Empty rows.")
        }
        width = data.first?.count ?? 0
        height = data.count
        _buffer = data.flatMap { $0 }
    }
}

// MARK: - Shallow Init Tooling

extension Grid {
    internal init(_ width: Int, _ height: Int) {
        self.width = width
        self.height = height
        _buffer = []
        _buffer.reserveCapacity(width * height)
    }
    
    internal mutating func append(_ element: Element) {
        _buffer.append(element)
    }
}

// MARK: - Base Collection Conformances

extension Grid {
    public var startIndex: Int { _buffer.startIndex }
    public var endIndex: Int { _buffer.endIndex }

    public func index(after i: Int) -> Int { i + 1 }
    public func index(before i: Int) -> Int { i - 1 }

    public subscript(idx: Index) -> Element {
        get {
            _subscriptPrecondition(idx)
            return _buffer[idx]
        }
        set {
            _subscriptPrecondition(idx)
            _buffer[idx] = newValue
        }
    }
}

// MARK: - Grid Subscript Access

extension Grid {
    public subscript(x: Int, y: Int) -> Element {
        get {
            _subscriptPrecondition(Location(x, y))
            return self[x + (width * y)]
        }
        set {
            _subscriptPrecondition(Location(x, y))
            self[x + (width * y)] = newValue
        }
    }
    
    public subscript(loc: Location) -> Element {
        get { self[loc.x, loc.y] }
        set { self[loc.x, loc.y] = newValue }
    }
    
    public subscript(locations: Set<Location>) -> [Element] {
        get {
            locations.compactMap({  self.contains($0) ? self[$0] : nil })
        }
        set {
            fatalError("Not implemented yet")
        }
    }
    
    public subscript(vector: (Int, Int)) -> Element {
        get { self[vector.0, vector.1] }
        set { self[vector.0, vector.1] = newValue }
    }
} 

// MARK: - Grid Methods

extension Grid {
    public func contains(_ location: Location) -> Bool {
        guard location.x >= 0 && location.x < width else { return false }
        guard location.y >= 0 && location.y < height else { return false }
        return true
    }

    public func location(for index: Index) -> Location {
        let (y, x) = index.quotientAndRemainder(dividingBy: width)
        return Location(x, y)
    }
    
    public var locations: [Location] {
        self.indices.map({ self.location(for: $0) })
    }
    
    public func withLocations() -> Grid<(Location, Element)> {
        var newGrid = Grid<(Location, Element)>(self.width, self.height)
        for index in self.indices {
            let location = self.location(for: index)
            newGrid.append((location, self[location]))
        }
        return newGrid
    }
    
    public func map<T>(_ transform: (Element) -> T) -> Grid<T> {
        var newGrid = Grid<T>(self.width, self.height)
        for index in self.indices {
            newGrid.append(transform(self[index]))
        }
        return newGrid
    }
    
    public func map<T>(withLocation transform: (Location, Element) -> T) -> Grid<T> {
        var newGrid = Grid<T>(self.width, self.height)
        for index in self.indices {
            let location = self.location(for: index)
            newGrid.append(transform(location, self[location]))
        }
        return newGrid
    }
    
    public func subgrid(from upperLeftCorner: Location, to lowerRightCorner: Location) -> Grid<Element> {
        fatalError("Not implemented yet")
    }
}

// MARK: - Special Cases

extension Grid: Equatable where Element: Equatable {}
extension Grid: Hashable where Element: Hashable {}
extension Grid: Codable where Element: Codable {}

extension Grid where Element: Hashable {
    public func values(for locations: Set<Location>) -> [Element:Int] {
        locations.reduce(into: [Element:Int](), { result, location in 
            if self.contains(location) {
                result[self[location], default: 0] += 1
            }
        })
    }
}

extension Grid where Element == Character {
    public static func from(multiLineString string: String) throws -> Grid<Character> {
        let array = string.split(separator: "\n").filter({ !$0.isEmpty })
            .map({ Array($0)})
        return try self.init(data: array)
    }
}

extension Grid: CustomStringConvertible where Element: CustomStringConvertible {
    public var description: String {
        var result = ""
        for y in 0..<height {
            for x in 0..<width {
                result += "\(self[x, y])"
            }
            result += "\n"
        }
        return result
    }
}
