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
        XCTAssertNotEqual(Position(lie: .green, yardage: .feet(21)), .init(lie: .green, yardage: .yards(7)))
    }
    
    func testExpectedShotType() {
        XCTAssertEqual(Position(lie: .green, yardage: .feet(67)).expectedShotType(), .putt)
    }
    
    func testExpectedShotType2() {
        XCTAssertEqual(Position(lie: .green, yardage: .feet(67)).expectedShotType(), .putt)
    }
    
    

    

    

    

}
