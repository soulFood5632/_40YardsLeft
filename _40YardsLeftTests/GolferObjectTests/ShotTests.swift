//
//  ShotTests.swift
//  _40YardsLeftTests
//
//  Created by Logan Underwood on 2023-05-14.
//

import XCTest
@testable import _40YardsLeft

final class ShotTests: XCTestCase {




    func testSimpleShot() throws {
        let shot = Shot(
            type: .drive,
            startPosition: .init(lie: .tee, yardage: .yards(456)),
            endPosition: .init(lie: .fairway, yardage: .yards(201))
        )
        
        XCTAssertEqual(shot.numOfShots, 1)
    }
    
    func testSimpleShot2() throws {
        let shot = Shot(
            type: .drive,
            startPosition: .init(lie: .tee, yardage: .yards(456)),
            endPosition: .init(lie: .fairway, yardage: .yards(201))
        )
        
        XCTAssertEqual(shot.includesPenalty, false)
    }
    
    func testSimpleShot3() throws {
        let shot = Shot(
            type: .drive,
            startPosition: .init(lie: .tee, yardage: .yards(456)),
            endPosition: .init(lie: .fairway, yardage: .yards(201))
        )
        
        XCTAssertEqual(shot.startPosition, .init(lie: .tee, yardage: .yards(456)))
    }
    
    func testSimpleShot4() throws {
        let shot = Shot(
            type: .drive,
            startPosition: .init(lie: .tee, yardage: .yards(456)),
            endPosition: .init(lie: .fairway, yardage: .yards(201))
        )
        
        XCTAssertEqual(shot.endPosition, .init(lie: .fairway, yardage: .yards(201)))
    }
    
    func testSimpleShot5() throws {
        let shot = Shot(
            type: .drive,
            startPosition: .init(lie: .tee, yardage: .yards(456)),
            endPosition: .init(lie: .fairway, yardage: .yards(201))
        )
        
        XCTAssertEqual(shot.type, .drive)
    }
    
    func testSimpleShot6() throws {
        let shot = Shot(
            type: .drive,
            startPosition: .init(lie: .tee, yardage: .yards(456)),
            endPosition: .init(lie: .fairway, yardage: .yards(201))
        )
        
        XCTAssertEqual(shot.advancementYardage, .yards(456) - .yards(201))
    }
    
    func testSimpleShot7() throws {
        let shot = Shot(
            type: .drive,
            startPosition: .init(lie: .tee, yardage: .yards(456)),
            endPosition: .init(lie: .fairway, yardage: .yards(201))
        )
        
        XCTAssertEqual(shot.strokesGained!, -0.1, accuracy: 0.1)
    }
    
    func testStrokesGained1() throws {
        let shot = Shot(
            type: .drive,
            startPosition: .init(lie: .tee, yardage: .yards(156)),
            endPosition: .init(lie: .green, yardage: .yards(6))
        )
        
        XCTAssertEqual(shot.strokesGained!, 0.15, accuracy: 0.1)
    }
    
    func testStrokesGained2() throws {
        let shot = Shot(
            type: .drive,
            startPosition: .init(lie: .tee, yardage: .yards(156)),
            endPosition: .holed
        )
        
        XCTAssertEqual(shot.strokesGained!, 2, accuracy: 0.25)
    }
    
    



}
