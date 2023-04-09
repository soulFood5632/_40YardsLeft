//
//  _40YardsLeftTests.swift
//  _40YardsLeftTests
//
//  Created by Logan Underwood on 2023-04-07.
//

import XCTest
@testable import _40YardsLeft

final class DistanceTests: XCTestCase {

    func testDistanceAddition() throws {
        let distance1 = Distance.feet(10)
        let distance2 = Distance.feet(10)
        
        XCTAssertEqual(distance1 + distance2, .feet(20))
    }
    
    func testDistanceAddition4() throws {
        let distance1 = Distance.feet(10)
        let distance2 = Distance.feet(11)
        
        XCTAssertEqual(distance1 + distance2, .yards(7))
    }
    
    func testDistanceAddition2() throws {
        let distance1 = Distance.yards(10)
        let distance2 = Distance.feet(9)
        
        XCTAssertEqual(distance1 + distance2, .yards(13))
    }
    
    func testDistanceAddition3() throws {
        let distance1 = Distance.meters(10)
        let distance2 = Distance.zero
        
        XCTAssertEqual(distance1 + distance2, .meters(10))
    }
    
    func testDistanceZeroYardage() throws {
        
        XCTAssertEqual(.zero, Distance.meters(0))
    }
    
    func testDistanceZeroYardage2() throws {
        
        XCTAssertEqual(.zero, Distance.yards(0))
    }
    
    func testDistanceZeroYardage3() throws {
        
        XCTAssertEqual(.zero, Distance(meters: 0))
    }
    
    func testDistanceZeroYardage4() throws {
        
        XCTAssertEqual(.zero, Distance(feet: 0))
    }
    
    func testDistanceZeroYardage5() throws {
        
        XCTAssertEqual(.zero, Distance(yards: 0))
    }
    
    func testDistanceZeroYardage6() throws {
        
        XCTAssertEqual(.zero, Distance(feet: 0))
    }
    
    func testDistanceSubtractionYardage() throws {
        let distance1 = Distance.yards(10)
        let distance2 = Distance.feet(6)
        
        XCTAssertEqual(distance2 - distance1, Distance.yards(-8))
    }
    
    func testGetMeters() throws {
        
        XCTAssertEqual(9.0, Distance.yards(3).feet, accuracy: 0.01)
    }
    
    func testEquality1() throws {
        XCTAssertEqual(Distance.yards(9), Distance.feet(27))
    }
    
    func testScaleFactor1() throws {
        XCTAssertEqual(Distance.yards(9).scaleBy(2), Distance.feet(27 * 2))
    }
    
    func testScaleFactor2() throws {
        XCTAssertEqual(Distance.yards(9).scaleBy(0), .zero)
    }
    
    func testScaleFactor3() throws {
        XCTAssertEqual(Distance.yards(9).scaleBy(-1), Distance.yards(-9))
    }
    
    func testEncoder() throws {
        let distance1 = Distance(feet: 10)
        let encoder = JSONEncoder()
        let encodedValue = try encoder.encode(distance1)
        
        let decoderValue = try JSONDecoder().decode(Distance.self, from: encodedValue)
        
        XCTAssertEqual(distance1, decoderValue)
    }
    
    func testEncoder2() throws {
        let distance1 = Distance(feet: 15)
        let encoder = JSONEncoder()
        let encodedValue = try encoder.encode(distance1)
        
        let decoderValue = try JSONDecoder().decode(Distance.self, from: encodedValue)
        
        XCTAssertEqual(distance1, decoderValue)
    }
    
    


}
