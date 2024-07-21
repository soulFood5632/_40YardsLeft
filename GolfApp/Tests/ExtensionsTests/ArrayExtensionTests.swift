//
//  ArrayExtensionTests.swift
//  _40YardsLeftTests
//
//  Created by Logan Underwood on 2023-04-10.
//

import XCTest
@testable import _40YardsLeft

final class ArrayExtensionTests: XCTestCase {

    

    func testRemoveAfter() throws {
        let array = [1, 2, 3, 4, 5]
        
        
        XCTAssertEqual([1, 2, 3], array.keepFirst(3))
    }
    
    func testRemoveAfter2() throws {
        let array = [1, 2, 3, 4, 5]
        
        
        XCTAssertEqual([], array.keepFirst(0))
    }
    
    func testRemoveAfter3() throws {
        let array = [1, 2, 3, 4, 5]
        
        XCTAssertEqual([1, 2, 3, 4, 5], array.keepFirst(8))
    }
    
    func testIsUnique() throws {
        XCTAssertTrue([1, 2, 3, 4, 5].isUnique)
    }
    
    func testIsUnique2() throws {
        XCTAssertFalse([1, 2, 3, 4, 4].isUnique)
    }
    
    func testIsUnique3() throws {
        XCTAssertTrue([Int]().isUnique)
    }

    func testIsUnique4() throws {
        XCTAssertFalse([1, 1].isUnique)
    }
    

}
