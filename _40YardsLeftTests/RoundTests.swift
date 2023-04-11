//
//  RoundTests.swift
//  _40YardsLeftTests
//
//  Created by Logan Underwood on 2023-04-10.
//

import XCTest
@testable import _40YardsLeft

final class RoundTests: XCTestCase {

    

    func testExample() throws {
        let round = try Round(course: .example1, tee: Course.example1.listOfTees[0])
        
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
