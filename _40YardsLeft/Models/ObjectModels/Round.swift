//
//  Round.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-25.
//

import Foundation

//MARK: Round Initilizers
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

//MARK: Round Extension
extension Round {
    
    static let example1 = try! Round(course: .example1, tee: Course.example1.listOfTees[0], date: .now)
    
    
    /// Finds if the provided hole has valid entries (could be submitted)
    ///
    /// - Parameter hole: The hole number you are looking. It must be a valid number which exists in this round.
    /// - Returns: True if the hole is complete, false otherwise
    func isHoleFilled(_ hole: Int) -> Bool {
        precondition(hole > 0)
        precondition(hole < self.holes.count)
        return holes[hole].isComplete
    }
}

enum GolfErrors : Error {
    case teeDoesntExist
}
