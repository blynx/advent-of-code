import Testing
@testable import SwiftGrid

@Suite struct GridTests {
    let smallStringGrid = 
        """
        012
        345
        678
        """
    
    let smallIntGrid = [
        [0,1,2],
        [3,4,5],
        [6,7,8],
    ]
    
    let largeStringGrid =
        """
        01234
        1x___
        2xx__
        3xxx_
        4xxxx
        """

    @Test("Grid init: with data, width and height")
    func initWidthHeightTest() throws {
        let nilGrid = try? Grid.init(data: [1,2,3,4], width: 2, height: 3)
        let grid = try Grid.init(data: [1,2,3,4], width: 2, height: 2)
        
        #expect(nilGrid == nil)
        #expect(grid.count == 4)
    }
    
    @Test("Grid init: with multidimensional array")
    func initMultidimArrayTest() throws {
        let nilGrid1 = try? Grid.init(data: [[], []])
        let nilGrid2 = try? Grid.init(data: [[1], [2, 3]])
        let grid = try Grid.init(data: [[1, 2, 3], [4, 5, 6]])
        
        #expect(nilGrid1 == nil)
        #expect(nilGrid2 == nil)
        #expect(grid.count == 6)
    }
    
    @Test("Grid init: from multi line string")
    func initFromStringTest() throws {
        let gridString =    """
                            012
                            345
                            678
                            """
        let grid = try! Grid<Character>.from(multiLineString: gridString)
        
        #expect(grid.count == 9)
        #expect(grid.width == 3)
        #expect(grid.height == 3)
    }
    
    @Test() func subscriptSetAccessTest() throws {
        let grid = try Grid<Character>.from(multiLineString: largeStringGrid)
        
        let edgeNeighbors = grid[Location(4,4).neighbors]
        #expect(edgeNeighbors.filter({ $0 == "_"}).count == 1)
        #expect(edgeNeighbors.filter({ $0 == "x"}).count == 2)
        
        let centerNeighbors = grid[Location(2,2).neighbors]
        #expect(centerNeighbors.filter({ $0 == "_"}).count == 3)
        #expect(centerNeighbors.filter({ $0 == "x"}).count == 5)
    }
    
    @Test() func mapWithElementTest() throws {
        let grid = try Grid(data: smallIntGrid)
        let it = grid.map { $0 % 2 == 0 ? 1 : 0 }
        #expect(it.description == "101\n010\n101\n")
    }
    
    @Test() func mapWithElementAndLocationTest() throws {
        let grid = try Grid(data: smallIntGrid)
        let it = grid.map(withLocation: { location, _  in location.x == 1 || location.y == 1 ? 1 : 0 })
        #expect(it.description == "010\n111\n010\n")
    }

    @Test() func someTest() throws {
        let grid = try Grid<Character>.from(multiLineString: smallStringGrid)
        let it = grid.locations.filter { $0.x == 1 || $0 == Location(2, 2) }
        #expect(it.count == 4)
    }
}
