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

    

}
