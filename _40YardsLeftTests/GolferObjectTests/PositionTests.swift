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
    
    func testExpectedShotValue4() throws {
        
        XCTAssertEqual(try Position(lie: .fairway, yardage: .yards(150)).getExpectedStrokes(), 3, accuracy: 0.25)
    }
    
    func testExpectedShotValue5() throws {
        
        XCTAssertEqual(try Position(lie: .green, yardage: .feet(8)).getExpectedStrokes(), 1.5, accuracy: 0.25)
    }
    
    func testExpectedShotValue6() throws {
        
        XCTAssertEqual(try Position(lie: .green, yardage: .feet(30)).getExpectedStrokes(), 2.05, accuracy: 0.25)
    }
    
    func testExpectedShotValue7() throws {
        
        XCTAssertEqual(try Position.holed.getExpectedStrokes(), 0, accuracy: 0.25)
    }
    
    func testExpectedShotValue8() throws {
        
        XCTAssertEqual(try Position.init(lie: .green, yardage: .feet(1)).getExpectedStrokes(), 1, accuracy: 0.1)
        
    }
    
    func testExpectedShotValue9() throws {
        
        XCTAssertEqual(try Position.init(lie: .green, yardage: .feet(2)).getExpectedStrokes(), 1, accuracy: 0.1)
        print(try Position.init(lie: .green, yardage: .feet(2)).getExpectedStrokes())
    }
    
    func testExpectedShotValue10() throws {
        
        XCTAssertEqual(try Position.init(lie: .green, yardage: .feet(3)).getExpectedStrokes(), 1.1, accuracy: 0.1)
        print(try Position.init(lie: .green, yardage: .feet(3)).getExpectedStrokes())
    }
    
   
    
    

    

    

    

}
