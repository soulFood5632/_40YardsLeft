//
//  Round.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-25.
//

import Foundation

struct Round : Equatable, Codable {
    
    let course: Course
    let tee: Tee
    var holes: [Hole]
    
    init(course: Course, tee: Tee) {
        self.course = course
        self.tee = tee
        self.holes = Self.getSkeletonHoles(from: tee)
    }
    
    private static func getSkeletonHoles(from tee: Tee) -> [Hole] {
        return tee.holeData.map { Hole(holeData: $0) }
    }
    
}
