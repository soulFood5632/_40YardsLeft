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
        precondition(hole <= self.holes.count)
        //hole minus 1 becuase of natural indexing
        return holes[hole - 1].isComplete
    }
    
    
    private func getFrontNine() -> [Hole] {
        var frontNine = self.holes
        frontNine.removeLast(9)
        
        return frontNine
    }
    
    private func getBackNine() -> [Hole] {
        var frontNine = self.holes
        frontNine.removeFirst(9)
        
        return frontNine
    }
    
    
    /// The score of the golfer on this front nine thus far
    var frontNineScore: Int {
        let frontNine = self.getFrontNine()
        return frontNine.map { $0.score }.reduce(0) { partialResult, score in
            return partialResult + score
        }
    }
    
    var backNineScore: Int {
        let backNine = self.getBackNine()
        return backNine.map { $0.score }.reduce(0) { partialResult, score in
            return partialResult + score
        }
    }
    
    var roundScore: Int {
        return backNineScore + frontNineScore
    }
    
    var frontNinePar: Int {
        let frontNine = self.getFrontNine()
        return frontNine.map { $0.holeData.par }.reduce(0) { partialResult, par in
            return partialResult + par
        }
    }
    
    var backNinePar: Int {
        let frontNine = self.getFrontNine()
        return frontNine.map { $0.holeData.par }.reduce(0) { partialResult, par in
            return partialResult + par
        }
    }
    
    var totalPar: Int {
        return backNinePar + frontNinePar
    }
    
    var scoreToPar: Int {
        return roundScore - totalPar
    }
    
    
    /// The number of holes that have been entered succsefuly
    ///
    /// A succseful hole entry is defined as a hole which's last shot ends in the hole. As a conseqeunce that means each hole must have at least one shot.
    ///
    /// - Returns: The number of holes which have been succsefully entered
    func numberOfHolesEntered() -> Int {
        return self.holes.map { $0.isComplete }.filter { $0 == true }.count
    }
    
    /// Is the round complete (do all holes have entries)
    var isComplete: Bool {
        //TODO: allow for different length of rounds functionality
        return numberOfHolesEntered() == 18
    }
    
    
    var getShots: [Shot] {
        return self.holes.map { $0.shots }.reduce([Shot]()) { partialresult, newShotList in
            var tempArr = partialresult
            tempArr.append(contentsOf: newShotList)
            return partialresult
        }
    }
    
}

enum GolfErrors : Error {
    case teeDoesntExist
}
