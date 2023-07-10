//
//  PositionTests.swift
//  _40YardsLeftTests
//
//  Created by Logan Underwood on 2023-04-09.
//

import XCTest
@testable import _40YardsLeft

final class PositionTests: XCTestCase {
    
    func testPositionEquality() {
        XCTAssertNotEqual(Position(lie: .green, yardage: .feet(23)), .holed)
    }
    
    func testPositionEquality2() {
        XCTAssertEqual(Position(lie: .green, yardage: .feet(23)), .init(lie: .green, yardage: .feet(23)))
    }
    
    func testPositionEquality3() {
        XCTAssertNotEqual(Position(lie: .green, yardage: .feet(21)), .init(lie: .green, yardage: .yards(8)))
    }
    
    func testExpectedShotType() {
        XCTAssertEqual(Position(lie: .green, yardage: .feet(67)).expectedShotType(), .atHole)
    }
    
    func testExpectedShotType2() {
        XCTAssertEqual(Position(lie: .green, yardage: .feet(67)).expectedShotType(), .atHole)
    }
    
    func testExpectedShotValue() throws {
        
        XCTAssertEqual(try Position(lie: .fairway, yardage: .yards(100)).getExpectedStrokes(), 2.87, accuracy: 0.25)
    }
    
    func testExpectedShotValue2() throws {
        
        XCTAssertEqual(try Position(lie: .rough, yardage: .yards(100)).getExpectedStrokes(), 3.03, accuracy: 0.25)
    }
    
    func testExpectedShotValue3() throws {
        
        XCTAssertEqual(try Position(lie: .bunker, yardage: .yards(100)).getExpectedStrokes(), 3.15, accuracy: 0.25)
    }
    
    

    

    

    

}
