//
//  Round.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-25.
//

import Foundation

//MARK: Round Initilizers
struct Round : Codable, Identifiable {
    /// A stable identifier for the round
    let id: UUID
    
    
    let course: Course
    let tee: Tee
    var holes: [Hole]
    var date: Date
    var roundType: RoundType
    
    init(course: Course, tee: Tee, date: Date, roundType: RoundType) throws {
        if !course.hasTee(tee) {
            throw GolfErrors.teeDoesntExist
        }
        self.id = UUID()
        self.course = course
        self.tee = tee
        self.holes = Self.getSkeletonHoles(from: tee)
        self.date = date
        self.roundType = roundType
    }
    
    init(course: Course, tee: Tee, roundType: RoundType) throws {
        try self.init(course: course, tee: tee, date: .now, roundType: roundType)
    }
    
    private static func getSkeletonHoles(from tee: Tee) -> [Hole] {
        return tee.holeData.map { Hole(holeData: $0) }
    }
    
    private static let SLOPE_CONSTANT = 113
    
}

extension Round: Equatable {
    static func ==(rhs: Round, lhs: Round) -> Bool {
        return rhs.id == lhs.id
    }
}

//MARK: Round Extension
extension Round {
    /// An example round that does not contain any shot entries.
    static let emptyRoundExample1 = try! Round(course: .example1, tee: Course.example1.listOfTees[0], date: .now, roundType: .casual)
    
    static let completeRoundExample1 = {
        var round = try! Round(course: .example1, tee: Course.example1.listOfTees[0], roundType: .competative)
        
        let sampleShotList: [Shot] = [
            .init(type: .drive, startPosition: Position(lie: .tee, yardage: .yards(430)), endPosition: Position(lie: .fairway, yardage:.yards(196))),
            Shot(type: .approach, startPosition: .init(lie: .fairway, yardage: .yards(196)), endPosition: .init(lie: .green, yardage: .feet(35))),
            Shot(type: .putt, startPosition: .init(lie: .green, yardage: .feet(35)), endPosition: .init(lie: .green, yardage: .feet(2))),
            Shot(type: .putt, startPosition: .init(lie: .green, yardage: .feet(2)), endPosition: .holed)
        ]
        //note the use of a index iterator becuase of the immutability of structs.
        for indexes in round.holes.indices {
            round.holes[indexes].addShots(sampleShotList)
        }
        
        return round
    }()
    
    
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
    
    private func getHoles(in range: ClosedRange<Int>) -> [Hole] {
        //TODO: Finish this method. 
        return self.holes
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
    
    /// The number of holes that have been entered succsefuly
    ///
    /// A succseful hole entry is defined as a hole which's last shot ends in the hole. As a conseqeunce that means each hole must have at least one shot.
    ///
    /// - Returns: The number of holes which have been succsefully entered
    func numberOfHolesEntered() -> Int {
        return self.holes.map { $0.isComplete }.filter { $0 == true }.count
    }
    
    func subscore(_ range: ClosedRange<Int>) -> Int {
        //TODO: Finish this method
        return 0
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
    
    /// Is the round complete (do all holes have entries)
    var isComplete: Bool { return numberOfHolesEntered() == self.numberOfHoles }
    
    var totalPar: Int {
        return backNinePar + frontNinePar
    }
    
    var scoreToPar: Int {
        if isComplete {
            return roundScore - totalPar
        }
        
        return holes.filter { $0.isComplete }.reduce(0) { partialResult, hole in
            return partialResult + hole.scoreToPar
        }
    }
    
    
    
    
    
    
    
    /// A list of all simplified shots (do not contain penalties).
    ///
    /// - Requires: That all holes have valid entries and are complete (per the method isHoled). This round must be complete before calling this method. 
    ///
    /// This method may throw a precondition error if it is called when the round is not complete.
    func getShots() -> [Shot] {
        do {
            return try self.holes.map { try $0.getSimplifiedShots() }.reduce([Shot]()) { partialresult, newShotList in
                var tempArr = partialresult
                tempArr.append(contentsOf: newShotList)
                return partialresult
            }
        } catch {
            preconditionFailure("The method gets shots was called before all of the holes were finished")
        }
        
    }
    
    
    /// The number of holes that this round is played on.
    ///
    /// This value should never be anything other than 9 or 18
    var numberOfHoles: Int { self.holes.count }
    
    
    
    /// The differential of the the round.
    var differential: Double {
        //TODO: change to ESC adjusted score (you will need to store the handicap of the golfer at the point of the round)
        return (Double(self.roundScore) - self.tee.rating) * Double(self.tee.slope) / Double(Self.SLOPE_CONSTANT)
    }
    
}

enum GolfErrors : Error {
    case teeDoesntExist
}

enum RoundType : String, CaseIterable, Codable {
    case tournament = "Tournament"
    case casual = "Casual"
    case competative = "Competative"
}


