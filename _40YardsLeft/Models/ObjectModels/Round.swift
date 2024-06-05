//
//  Round.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-25.
//

import Foundation

//MARK: Round Initilizers
struct Round : Codable, Identifiable, Hashable {
    
    /*
     Rep Invariant:
     self.course.tees.contains(self.tee)
     for all self.holes.holeData is contained in self.course.tees.holeData
     */
    
    /// A stable identifier for the round
    let id: UUID
    
    /// The course where the round was played on.
    let course: Course
    /// The tee in which this round takes place on
    let tee: Tee
    /// A list of holes which contain the data of the round.
    var holes: [Hole]
    
    /// The date in which this round takes place on
    var date: Date
    /// The type of round that this is.
    var roundType: RoundType
    
    /// Creates a new round with an explicit date from the given course, tee, and the provided round type
    ///
    /// - Throws: `GolfError.teeDoesNotExist` if the provided tee does not exist.
    /// - Parameters:
    ///   - course: The course where this round takes place
    ///   - tee: The tee where this round is being played off of. If the tee is not a member of ht eprovided course an error will throw.
    ///   - date: The time when this round was played.
    ///   - roundType: The type of round which is being played.
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
    
    
    /// Creates a new round with an implicit date which is set to now from the given course, tee, and the provided round type
    ///
    /// - Throws: `GolfError.teeDoesNotExist` if the provided tee does not exist.
    /// - Parameters:
    ///   - course: The course where this round takes place
    ///   - tee: The tee where this round is being played off of. If the tee is not a member of ht eprovided course an error will throw.
    ///   - roundType: The type of round which is being played.
    init(course: Course, tee: Tee, roundType: RoundType) throws {
        try self.init(course: course, tee: tee, date: .now, roundType: roundType)
    }
    
    
    /// Gets holes with no shot data.
    ///
    /// - Parameter tee: The tee which this skeleton data should be pulled from
    /// - Returns: A list of holes which contains holes with hole data from the provided tee.
    private static func getSkeletonHoles(from tee: Tee) -> [Hole] {
        return tee.holeData.map { Hole(holeData: $0) }
    }
    /// An average slope value from RCGA, USGA
    private static let SLOPE_CONSTANT = 113
    
}

extension Round: Equatable {
    static func == (rhs: Round, lhs: Round) -> Bool {
        return rhs.id == lhs.id && rhs.course == lhs.course && rhs.holes == lhs.holes && rhs.tee == lhs.tee 
    }
}

//MARK: Round Extension
extension Round {
    /// An example round that does not contain any shot entries.
    static let emptyRoundExample1 = try! Round(course: .example1, tee: Course.example1.listOfTees[0], date: .now, roundType: .casual)
    /// An example round which contains the score 4 on every hole.
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
    

    
    /// Gets holes within the provided closed range.
    ///
    /// - Important: The input range is of hole numbers not indexes.
    ///
    /// - Parameter range: The closed range of hole numbers that you would like to collect from.
    /// - Returns: All of the holes within the provided range.
    private func getHoles(in range: ClosedRange<Int>) -> [Hole] {
        //TODO: Finish this method. 
        return self.holes
    }
    
    
    private func getFrontNine() -> [Hole] {
        var frontNine = self.holes
        frontNine.removeLast(9)
        //TODO: reimploment this area with the new getHoles in range.
        
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
    
    
    /// The total round score.
    var roundScore: Int {
        return backNineScore + frontNineScore
    }
    
    //TODO: fix up this area and improve the code to reduce the number of stored values.
    
    var frontNinePar: Int {
        let frontNine = self.getFrontNine()
        return frontNine.map { $0.holeData.par }.reduce(0) { partialResult, par in
            return partialResult + par
        }
    }
    
    var backNinePar: Int {
        let backNine = self.getBackNine()
        return backNine.map { $0.holeData.par }.reduce(0) { partialResult, par in
            return partialResult + par
        }
    }
    
    /// Are all the holes complete
    var isComplete: Bool { return numberOfHolesEntered() == self.numberOfHoles }
    
    var totalPar: Int {
        return backNinePar + frontNinePar
    }
    
    
    /// The current score to par of the round
    ///
    /// - This variable can be called during the round (it need to not be complete).
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
            return try self.holes.map { try $0.getSimplifiedShots() }.flatten()
            
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
    
    
    /// Gets the total strokes gained on the round approach.
    ///
    /// - Requires: The round be complete.
    ///
    /// - Returns: A double value contaning the strokes gained on approach during this round.
    func strokesGainedApproach() -> Double {
        do {
            return try self.holes
                .map { try $0.getSimplifiedShots() }
                .flatten()
                .strokesGained(ShotFilters.allApproach)
        } catch {
            
            preconditionFailure("all holes should be complete prior to the calling of this method.")
        }
    }
    
    func strokesGainedShortGame() -> Double {
        do {
            return try self.holes
                .map { try $0.getSimplifiedShots() }
                .flatten()
                .strokesGained(ShotFilters.allShortGame)
        } catch {
            
            preconditionFailure("all holes should be complete prior to the calling of this method.")
        }
    }
    
    func strokesGainedTee() -> Double {
        do {
            return try self.holes
                .map { try $0.getSimplifiedShots() }
                .flatten()
                .strokesGained(ShotFilters.allTeeShots)
        } catch {
            
            preconditionFailure("all holes should be complete prior to the calling of this method.")
        }
    }
    
    func strokesGainedPutting() -> Double {
        do {
            return try self.holes
                .map { try $0.getSimplifiedShots() }
                .flatten()
                .strokesGained(ShotFilters.allPutts)
        } catch {
            
            preconditionFailure("all holes should be complete prior to the calling of this method.")
        }
    }
    
    func strokesGainedOther() -> Double {
        do {
            return try self.holes
                .map { try $0.getSimplifiedShots() }
                .flatten()
                .strokesGained(ShotFilters.allOther)
        } catch {
            
            preconditionFailure("all holes should be complete prior to the calling of this method.")
        }
    }

}

extension Round {
    
    @discardableResult
    /// Updates the provided hole with the new data.
    ///
    /// - Important: The shots in the given hole will be overridden.
    ///
    /// - Parameters:
    ///   - holeNumber: The hole number you would like to update.
    ///   - shots: The list of shots you would like to put into the hole
    /// - Returns: A list of booleans which represent whether each shot addition was succseful.
    mutating func updateHole(_ holeNumber: Int, with shots: [Shot]) -> [Bool] {
        
        self.holes[holeNumber - 1].resetShots()
        let value = self.holes[holeNumber - 1].addShots(shots)

        return value
    }
}




/// Errors related to round entry
enum GolfErrors : Error {
    case teeDoesntExist
}

enum RoundType : String, CaseIterable, Codable {
    case tournament = "Tournament"
    case casual = "Casual"
    case competative = "Competative"
}

extension RoundType: Identifiable {
    var id: Self { self }
}

extension RoundType: StringRepresentable {
    func toString() -> String {
        return self.rawValue
    }
    
    
}

extension Array where Element: Sequence {
    func flatten() -> [Element.Element] {
        return self.flatMap { $0 }
    }
}




