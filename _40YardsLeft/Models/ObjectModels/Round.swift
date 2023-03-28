//
//  Round.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-25.
//

import Foundation

struct Round : Equatable, Codable {
    
    let course: Course
    var tee: Tee
    var holes: [Hole]
    var date: Date
    
    init(course: Course, tee: Tee, date: Date) throws {
        if !course.hasTee(tee) {
            throw GolfErrors.teeDoesntExist
        }
        self.course = course
        self.tee = tee
        self.holes = Self.getSkeletonHoles(from: tee)
        self.date = date
    }
    
    init(course: Course, tee: Tee) throws {
        try self.init(course: course, tee: tee, date: .now)
    }
    
    private static func getSkeletonHoles(from tee: Tee) -> [Hole] {
        return tee.holeData.map { Hole(holeData: $0) }
    }
    
}

enum GolfErrors : Error {
    case teeDoesntExist
}
