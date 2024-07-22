//
//  ShotEntryTests.swift
//  GolfAppTests
//
//  Created by Logan Underwood on 2024-07-21.
//

import XCTest

@testable import GolfApp

final class ShotEntryTests: XCTestCase {
  
  static func similarShots(shot1: Shot, shot2: Shot) -> Bool {
    return shot1.startPosition == shot2.startPosition && shot1.endPosition == shot2.endPosition && shot1.includesPenalty == shot2.includesPenalty && shot1.type == shot2.type
  }

  func testSimpleEntry() {
    let shots_int: [Shot] = [
      ShotIntermediate(
        position: .init(lie: .tee, yardage: .yards(465)),
        declaration: .drive
      ),
      ShotIntermediate(
        position: .init(lie: .fairway, yardage: .yards(156)),
        declaration: .atHole
      ),
      ShotIntermediate(
        position: .init(lie: .fairway, yardage: .yards(24)),
        declaration: .atHole
      ),
      ShotIntermediate(
        position: .init(lie: .green, yardage: .feet(4)),
        declaration: .atHole
      ),
    ].prepareShots()

    let shots: [Shot] = [
      .init(
        type: .drive,
        startPosition: .init(lie: .tee, yardage: .yards(465)),
        endPosition: .init(lie: .fairway, yardage: .yards(156))
      ),
      .init(
        type: .approach,
        startPosition: .init(lie: .fairway, yardage: .yards(156)),
        endPosition: .init(lie: .fairway, yardage: .yards(24))
      ),
      .init(
        type: .chip_pitch,
        startPosition: .init(lie: .fairway, yardage: .yards(24)),
        endPosition: .init(lie: .green, yardage: .feet(4))
      ),
      .init(
        type: .putt,
        startPosition: .init(lie: .green, yardage: .feet(4)),
        endPosition: .holed
      ),
    ]

    for i in shots.indices {

      XCTAssertTrue(Self.similarShots(shot1: shots[i], shot2: shots_int[i]))
    }

  }
  
  func testLongerEntry() {
    let shots_int: [Shot] = [
      ShotIntermediate(
        position: .init(lie: .tee, yardage: .yards(465)),
        declaration: .drive
      ),
      ShotIntermediate(position: .init(lie: .other, yardage: .yards(145)), declaration: .drop),
      ShotIntermediate(
        position: .init(lie: .rough, yardage: .yards(156)),
        declaration: .atHole
      ),
      ShotIntermediate(
        position: .init(lie: .fairway, yardage: .yards(24)),
        declaration: .atHole
      ),
      ShotIntermediate(
        position: .init(lie: .green, yardage: .feet(4)),
        declaration: .atHole
      ),
    ].prepareShots()
    
    let shots: [Shot] = [
      .init(
        type: .drive,
        startPosition: .init(lie: .tee, yardage: .yards(465)),
        endPosition: .init(lie: .rough, yardage: .yards(156)),
        includesPenalty: true
      ),
      .init(
        type: .approach,
        startPosition: .init(lie: .rough, yardage: .yards(156)),
        endPosition: .init(lie: .fairway, yardage: .yards(24))
      ),
      .init(
        type: .chip_pitch,
        startPosition: .init(lie: .fairway, yardage: .yards(24)),
        endPosition: .init(lie: .green, yardage: .feet(4))
      ),
      .init(
        type: .putt,
        startPosition: .init(lie: .green, yardage: .feet(4)),
        endPosition: .holed
      ),
    ]
    
    for i in shots.indices {

      XCTAssertTrue(Self.similarShots(shot1: shots[i], shot2: shots_int[i]))
    }
    
  }
  
  func testDropFromOther() {
    let shots_int: [Shot] = [
      ShotIntermediate(
        position: .init(lie: .tee, yardage: .yards(465)),
        declaration: .drive
      ),
      ShotIntermediate(position: .init(lie: .other, yardage: .yards(145)), declaration: .drop),
      ShotIntermediate(
        position: .init(lie: .other, yardage: .yards(156)),
        declaration: .atHole
      ),
      ShotIntermediate(
        position: .init(lie: .fairway, yardage: .yards(24)),
        declaration: .atHole
      ),
      ShotIntermediate(
        position: .init(lie: .green, yardage: .feet(4)),
        declaration: .atHole
      ),
    ].prepareShots()
    
    let shots: [Shot] = [
      .init(
        type: .drive,
        startPosition: .init(lie: .tee, yardage: .yards(465)),
        endPosition: .init(lie: .other, yardage: .yards(156)),
        includesPenalty: true
      ),
      .init(
        type: .approach,
        startPosition: .init(lie: .other, yardage: .yards(156)),
        endPosition: .init(lie: .fairway, yardage: .yards(24))
      ),
      .init(
        type: .chip_pitch,
        startPosition: .init(lie: .fairway, yardage: .yards(24)),
        endPosition: .init(lie: .green, yardage: .feet(4))
      ),
      .init(
        type: .putt,
        startPosition: .init(lie: .green, yardage: .feet(4)),
        endPosition: .holed
      ),
    ]
    
    for i in shots.indices {
      
      XCTAssertTrue(Self.similarShots(shot1: shots[i], shot2: shots_int[i]))
    }
    
  }
  
  func testValidChecker() {
    var shots_int: [ShotIntermediate] = [
      ShotIntermediate(
        position: .init(lie: .tee, yardage: .yards(465)),
        declaration: .drive
      ),
      ShotIntermediate(position: .init(lie: .other, yardage: .yards(145)), declaration: .drop),
      ShotIntermediate(
        position: .init(lie: .other, yardage: .yards(156)),
        declaration: .atHole
      ),
      ShotIntermediate(
        position: .init(lie: .fairway, yardage: .yards(24)),
        declaration: .atHole
      ),
      
    ]
    
    XCTAssertNil(shots_int.is_valid())
    
    shots_int.append(ShotIntermediate(
      position: .init(lie: .green, yardage: .feet(4)),
      declaration: .atHole
    ))
    
    XCTAssertNil(shots_int.is_valid())
                     
  }
  
  func testOther() {
    let shots_int = [
      ShotIntermediate(
        position: .init(lie: .tee, yardage: .yards(465)),
        declaration: .drive
      ),
      ShotIntermediate(position: .init(lie: .other, yardage: .yards(145)), declaration: .other),
      ShotIntermediate(
        position: .init(lie: .other, yardage: .yards(156)),
        declaration: .atHole
      ),
      ShotIntermediate(
        position: .init(lie: .fairway, yardage: .yards(24)),
        declaration: .atHole
      ),
      ShotIntermediate(
        position: .init(lie: .green, yardage: .feet(4)),
        declaration: .atHole
      ),
    ].prepareShots()
    
    let shots: [Shot] = [
      .init(
        type: .drive,
        startPosition: .init(lie: .tee, yardage: .yards(465)),
        endPosition: .init(lie: .other, yardage: .yards(145))
      ),
      .init(type: .other, startPosition: .init(lie: .other, yardage: .yards(145)), endPosition: .init(lie: .other, yardage: .yards(156))),
      .init(
        type: .approach,
        startPosition: .init(lie: .other, yardage: .yards(156)),
        endPosition: .init(lie: .fairway, yardage: .yards(24))
      ),
      .init(
        type: .chip_pitch,
        startPosition: .init(lie: .fairway, yardage: .yards(24)),
        endPosition: .init(lie: .green, yardage: .feet(4))
      ),
      .init(
        type: .putt,
        startPosition: .init(lie: .green, yardage: .feet(4)),
        endPosition: .holed
      ),
    ]
    
    for i in shots.indices {
      
      XCTAssertTrue(Self.similarShots(shot1: shots[i], shot2: shots_int[i]))
    }
  }
  
  func testStrangeFirstShot() {
    XCTAssertNotNil([ShotIntermediate(position: .holed, declaration: .other)].is_valid())
    XCTAssertNil([ShotIntermediate(position: .init(lie: .tee, yardage: .yards(154)), declaration: .atHole)].is_valid())
    XCTAssertNotNil([ShotIntermediate(position: .init(lie: .fairway, yardage: .yards(154)), declaration: .atHole)].is_valid())
    XCTAssertNotNil([ShotIntermediate(position: .init(lie: .other, yardage: .yards(154)), declaration: .atHole)].is_valid())
    XCTAssertNil([ShotIntermediate(position: .init(lie: .tee, yardage: .yards(453)), declaration: .drive)].is_valid())
    XCTAssertNotNil([ShotIntermediate(position: .init(lie: .tee, yardage: .yards(154)), declaration: .drop)].is_valid())
    XCTAssertNotNil([ShotIntermediate(position: .init(lie: .tee, yardage: .yards(154)), declaration: .drop)].is_valid())
  }
  
  func testMultiShot() {
    XCTAssertNotNil([
      ShotIntermediate(position: .init(lie: .tee, yardage: .yards(156)), declaration: .atHole),
      ShotIntermediate(position: .init(lie: .fairway, yardage: .yards(23)), declaration: .drop)
    ].is_valid())
    XCTAssertNil([
      ShotIntermediate(position: .init(lie: .tee, yardage: .yards(156)), declaration: .atHole),
      ShotIntermediate(position: .init(lie: .fairway, yardage: .yards(23)), declaration: .other)
    ].is_valid())
    XCTAssertNil([
      ShotIntermediate(position: .init(lie: .tee, yardage: .yards(156)), declaration: .atHole),
      ShotIntermediate(position: .init(lie: .fairway, yardage: .yards(23)), declaration: .atHole)
    ].is_valid())
    XCTAssertNil([
      ShotIntermediate(position: .init(lie: .tee, yardage: .yards(156)), declaration: .atHole),
      ShotIntermediate(position: .init(lie: .fairway, yardage: .yards(23)), declaration: .drive)
    ].is_valid())
    XCTAssertNil([
      ShotIntermediate(position: .init(lie: .tee, yardage: .yards(156)), declaration: .drive),
      ShotIntermediate(position: .init(lie: .fairway, yardage: .yards(23)), declaration: .drive)
    ].is_valid())
  }
  
  

}
