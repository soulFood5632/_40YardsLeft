//
//  RoundTests.swift
//  _40YardsLeftTests
//
//  Created by Logan Underwood on 2023-04-10.
//

import XCTest
@testable import _40YardsLeft

final class RoundTests: XCTestCase {
    
    private static func getCourse1() -> Course {
        var course = Course(location: Address(addressLine1: "Morning Street", city: "Victoria", province: .BC, country: .Canada), name: "Northern Slopes Golf and Country Club")
        do {
            course.addTee(try getTee1())
            course.addTee(try getTee2())
            
        } catch {
            fatalError("irreversible error")
        }
        
        return course
    }
    
    private static func getRound1() -> Round {
        var course = Course(location: Address(addressLine1: "Morning Street", city: "Victoria", province: .BC, country: .Canada), name: "Northern Slopes Golf and Country Club")
        do {
            course.addTee(try getTee1())
            
            return try .init(course: course, tee: course.listOfTees[0], roundType: .casual)
            
        } catch {
            fatalError("irreversible error")
        }
        
        
    }
    
    private static func getRound2() -> Round {
        var course = Course(location: Address(addressLine1: "Morning Street", city: "Victoria", province: .BC, country: .Canada), name: "Northern Slopes Golf and Country Club")
        do {
            course.addTee(try getTee1())
            course.addTee(try getTee2())
            
            return try .init(course: course, tee: course.listOfTees[1], roundType: .casual)
            
        } catch {
            fatalError("irreversible error")
        }
        
        
    }
    
    private static func getTee1() throws -> Tee {
        return try Tee(rating: 71.8, slope: 125, holeData: [
            // front nine
            .init(yardage: .yards(456), handicap: 3, par: 4),
            .init(yardage: .yards(431), handicap: 7, par: 4),
            .init(yardage: .yards(516), handicap: 15, par: 5),
            .init(yardage: .yards(134), handicap: 17, par: 3),
            .init(yardage: .yards(386), handicap: 13, par: 4),
            .init(yardage: .yards(191), handicap: 5, par: 3),
            .init(yardage: .yards(621), handicap: 9, par: 5),
            .init(yardage: .yards(471), handicap: 1, par: 4),
            .init(yardage: .yards(365), handicap: 11, par: 4),
            //back nine
            .init(yardage: .yards(398), handicap: 16, par: 4),
            .init(yardage: .yards(297), handicap: 18, par: 5),
            .init(yardage: .yards(598), handicap: 12, par: 3),
            .init(yardage: .yards(391), handicap: 14, par: 4),
            .init(yardage: .yards(435), handicap: 6, par: 4),
            .init(yardage: .yards(204), handicap: 4, par: 5),
            .init(yardage: .yards(578), handicap: 10, par: 3),
            .init(yardage: .yards(192), handicap: 8, par: 5),
            .init(yardage: .yards(452), handicap: 2, par: 3),
        ], name: "Black")
    }
    
    private static func getTee2() throws -> Tee {
        
            return try Tee(rating: 69.4, slope: 120, holeData: [
                // front nine
                .init(yardage: .yards(435), handicap: 3, par: 4),
                .init(yardage: .yards(429), handicap: 7, par: 4),
                .init(yardage: .yards(487), handicap: 15, par: 5),
                .init(yardage: .yards(132), handicap: 17, par: 3),
                .init(yardage: .yards(381), handicap: 13, par: 4),
                .init(yardage: .yards(167), handicap: 5, par: 3),
                .init(yardage: .yards(587), handicap: 9, par: 5),
                .init(yardage: .yards(460), handicap: 1, par: 4),
                .init(yardage: .yards(365), handicap: 11, par: 4),
                //back nine
                .init(yardage: .yards(379), handicap: 16, par: 4),
                .init(yardage: .yards(297), handicap: 18, par: 5),
                .init(yardage: .yards(570), handicap: 12, par: 3),
                .init(yardage: .yards(378), handicap: 14, par: 4),
                .init(yardage: .yards(410), handicap: 6, par: 4),
                .init(yardage: .yards(174), handicap: 4, par: 5),
                .init(yardage: .yards(542), handicap: 10, par: 3),
                .init(yardage: .yards(157), handicap: 8, par: 5),
                .init(yardage: .yards(432), handicap: 2, par: 3),
            ], name: "Blue")
       
    }
    
    private static func getTee3() throws -> Tee {
        
        return try Tee(rating: 66.4, slope: 120, holeData: [
            // front nine
            .init(yardage: .yards(389), handicap: 3, par: 4),
            .init(yardage: .yards(378), handicap: 7, par: 4),
            .init(yardage: .yards(423), handicap: 15, par: 5),
            .init(yardage: .yards(105), handicap: 17, par: 3),
            .init(yardage: .yards(375), handicap: 13, par: 4),
            .init(yardage: .yards(154), handicap: 5, par: 3),
            .init(yardage: .yards(507), handicap: 9, par: 5),
            .init(yardage: .yards(398), handicap: 1, par: 4),
            .init(yardage: .yards(310), handicap: 11, par: 4),
            //back nine
            .init(yardage: .yards(343), handicap: 16, par: 4),
            .init(yardage: .yards(287), handicap: 18, par: 5),
            .init(yardage: .yards(540), handicap: 12, par: 3),
            .init(yardage: .yards(335), handicap: 14, par: 4),
            .init(yardage: .yards(375), handicap: 6, par: 4),
            .init(yardage: .yards(146), handicap: 4, par: 5),
            .init(yardage: .yards(500), handicap: 10, par: 3),
            .init(yardage: .yards(121), handicap: 8, par: 5),
            .init(yardage: .yards(378), handicap: 2, par: 3),
        ], name: "White")
        
    }
    
    
    
    func testInit1() throws {
        do {
            try Round(course: Self.getCourse1(), tee: try Self.getTee1(), roundType: .casual)
        } catch {
            XCTFail("Round init should not throw error becuase it is given a valid tee. ")
        }
        
    }
    
    func testInit2() throws {
        do {
            try  Round(course: Self.getCourse1(), tee: try Self.getTee2(), roundType: .tournament)
        } catch {
            XCTFail("Round init should not throw error becuase it is given a valid tee.")
        }
        
    }
    
    func testInit3() throws {
        do {
            try Round(course: Self.getCourse1(), tee: try Self.getTee3(), roundType: .tournament)
        } catch {
            return
        }
        XCTFail("Round init should throw error becuase it is not given a valid tee. ")
        
    }
    
    func testStartScores1() throws {
        XCTAssertEqual(Self.getRound1().roundScore, 0)
    }
    
    func testStartScores2() throws {
        XCTAssertEqual(Self.getRound1().roundScore, 0)
    }
    
    func testUpdateHoles1() {
        var exampleRound = Self.getRound1()
        
        exampleRound.updateHole(1, with: [
            Shot(type: .drive, startPosition: .init(lie: .tee, yardage: .yards(432)), endPosition: .init(lie: .fairway, yardage: .yards(165))),
            Shot(type: .approach, startPosition: .init(lie: .fairway, yardage: .yards(165)), endPosition: .init(lie: .green, yardage: .feet(32))),
            Shot(type: .putt, startPosition: .init(lie: .green, yardage: .feet(32)), endPosition: .holed)
        ])
        
        
        
        XCTAssertEqual(exampleRound.roundScore, 3)
    }
    
    func testUpdateHoles2() {
        var exampleRound = Self.getRound1()
        
        let shotArray = [
            Shot(type: .drive, startPosition: .init(lie: .tee, yardage: .yards(432)), endPosition: .init(lie: .fairway, yardage: .yards(165))),
            Shot(type: .approach, startPosition: .init(lie: .fairway, yardage: .yards(165)), endPosition: .init(lie: .green, yardage: .feet(32))),
            Shot(type: .putt, startPosition: .init(lie: .green, yardage: .feet(32)), endPosition: .holed)
        ]
        
        exampleRound.updateHole(1, with: shotArray)
        exampleRound.updateHole(2, with: shotArray)
        
        
        
        XCTAssertEqual(exampleRound.roundScore, 6)
    }
    
    func testUpdateHoles3() {
        var exampleRound = Self.getRound1()
        
        let shotArray = [
            Shot(type: .drive, startPosition: .init(lie: .tee, yardage: .yards(432)), endPosition: .init(lie: .fairway, yardage: .yards(165))),
            Shot(type: .approach, startPosition: .init(lie: .fairway, yardage: .yards(165)), endPosition: .init(lie: .green, yardage: .feet(32))),
            Shot(type: .putt, startPosition: .init(lie: .green, yardage: .feet(32)), endPosition: .holed)
        ]
        
        exampleRound.updateHole(1, with: shotArray)
        exampleRound.updateHole(2, with: shotArray)
        exampleRound.updateHole(2, with: [])
        
        
        
        XCTAssertEqual(exampleRound.roundScore, 3)
    }

}
