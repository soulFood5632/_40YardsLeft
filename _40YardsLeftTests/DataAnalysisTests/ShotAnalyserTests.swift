//
//  ShotAnalyserTests.swift
//  _40YardsLeftTests
//
//  Created by Logan Underwood on 2023-05-12.
//
@testable import _40YardsLeft
import XCTest

/// <#Description#>
final class ShotAnalyserTests: XCTestCase {

    /// A list of approach shots that contains the following data
    private static let approachShotList: [Shot] = [
        .init(type: .approach, startPosition: .init(lie: .fairway, yardage: .yards(150)), endPosition: .init(lie: .green, yardage: .feet(25))),
        .init(type: .approach, startPosition: .init(lie: .fairway, yardage: .yards(145)), endPosition: .init(lie: <#T##Lie#>, yardage: <#T##Distance#>))
    ]

    func testSingleShot() throws {
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
