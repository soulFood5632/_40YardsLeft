//
//  Golfer.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-25.
//

import Foundation


struct Golfer: Codable {
    private static let MINUMUM_SHOTS_FOR_ANALYSIS = 1000
    
    let firebaseID: String
    private(set) var rounds: [Round]
    var gender : Gender
    var name : String
    var homeCourse : Course?
    
    
    /// Creates a new instance of a golfer with no home course
    ///
    /// - Parameters:
    ///   - firebaseID: The firebase ID realted to this golfer
    ///   - gender: The gender of the golfer
    ///   - name: The name of the golfer
    init(firebaseID: String, gender: Gender, name: String) {
        self.firebaseID = firebaseID
        self.rounds = [Round]()
        self.gender = gender
        self.name = name
        
    }
    
    
    /// Creates a new instance of a golfer with the provided home course
    ///
    /// - Parameters:
    ///   - firebaseID: <#firebaseID description#>
    ///   - gender: <#gender description#>
    ///   - name: <#name description#>
    ///   - homeCourse: <#homeCourse description#>
    init(firebaseID: String, gender: Gender, name: String, homeCourse: Course) {
        self.firebaseID = firebaseID
        self.rounds = [Round]()
        self.gender = gender
        self.name = name
        self.homeCourse = homeCourse
        
    }
    
    
    

}

extension Golfer: Equatable {
    static func == (lhs: Golfer, rhs: Golfer) -> Bool {
        lhs.firebaseID == rhs.firebaseID
    }
}

extension Golfer {
    @discardableResult
    /// Adds the given round to this golfer.
    ///
    /// - Parameter round: The round you would like to add
    /// - Returns: False if the round already has been added, true if succseful.
    mutating func addRound(_ round : Round) -> Bool {
        if self.rounds.contains(round) {
            return false
        }
        
        self.rounds.append(round)
        return true
    }
    
    @discardableResult
    /// Deletes the provided round from this golfer
    ///
    /// - Note: This method uses the equality method found in `Round.self`.
    ///
    /// - Parameter round: The round you would like to delete
    /// - Returns: Returns true if the round was succsefully deleted, false if not round was contained in this golfers list of rounds.
    mutating func deleteRound(_ round: Round) -> Bool {
        if self.rounds.contains(round) {
            rounds.removeAll { $0 == round }
            return true
        }
        
        return false
    }
}

extension Golfer {
    /// A number of rounds played per day since the first round of the golfer.
    ///
    /// The number of days since the last round will use the defintion provided by `date.daysToNow()`
    var roundsPerDay: Double {
        if rounds.isEmpty {
            return 0
        }
        
        let earliestRound = rounds.sorted { round1, round2 in
            return round1.date > round2.date
        }
        .last!
        
        return Double(rounds.count) / Double(earliestRound.date.daysToNow())
    }
    
    /// Gets the list of rounds sorted by date (most recent to oldest)
    var roundsSortedByDate: [Round] {
        rounds.sorted(by: { round1, round2 in
            return round1.date > round2.date
        })
    }
}

extension Date {
    
    
    /// Gets the overestimated number of days until now.
    ///
    /// - Returns: The overestimated number of days until now since this date. If the provided date is in the future returns 0.
    func daysToNow() -> Int {
        let oneDayInSeconds = TimeInterval.days(1)
        
        let sinceNow = self.timeIntervalSince(.now)
        
        if sinceNow >= 0 {
            return 0
        }
        
        return Int(-(sinceNow / oneDayInSeconds).rounded(.awayFromZero))
    }
}


extension Golfer {
    
    /// The handicap of the golfer
    ///
    /// The handicap calculation follows the rules and regulations of RCGA, USGA, RGA. For more infromation please visit <\link>
    ///
    /// 
    var handicap: Double {
        let lastRounds = self.getLastRounds(20)
        
        switch lastRounds.count {
        case 1:
            return 0
        default:
            return 0
        }
        
        //TODO: Imploment this function
    }
    
    
    /// Gets the last `X` rounds by date
    ///
    /// - Parameter number: The number of rounds in the past you would like to collect.
    /// - Returns: A list of rounds ordered by newest to oldest containibng the latest `X` rounds from this golfer.
    func getLastRounds(_ number: Int) -> [Round] {
        self.rounds.sorted { round1, round2 in
            round1.date > round2.date
        }
        .keepFirst(number)
    }
    
    
    
    
    
    
}

extension Golfer {
    func getShotPredictor() async -> UserDistanceValues {
        let shots = self.getShots()
        let userValues = UserDistanceValues()
        if shots.count < Self.MINUMUM_SHOTS_FOR_ANALYSIS {
            return userValues
        }
        
        let shotAnalyzer = TendancyAnalyzer(shots: shots)
        
        //TODO: finish this method.
        async let driveDistance = shotAnalyzer.getDriveDistance()
        async let minApproachDistance = shotAnalyzer.getMinimumApproachAndMaxApproach().0
        async let maxApproachDistance = shotAnalyzer.getMinimumApproachAndMaxApproach().1
        
        
        
        //TODO: finish implementing this method.
        return UserDistanceValues()
        
        
    }
    
    
    
    
    /// Gets all of the shots of this golfer.
    /// - Returns: A list containing all of the shots of the golfer
    private func getShots() -> [Shot] {
        return Array.combine(arrays: self.rounds.map { $0.getShots() })
    }
    
}





//MARK: Array Helper Methods
extension Array {
    
    /// Combines the provided arrays into a single array.
    ///
    /// The new array will be ordered in such a way that the first array will be added to the array followed by the values in the next array.
    ///
    /// - Parameter arrays: A list of arrays of the same type which are to be combined.
    /// - Returns: A list of the combined lists in the order of the oiriginal provided list of arrays.
    static func combine(arrays: [[Element]]) -> [Element] {
        arrays.reduce([Element]()) { partialResult, list in
            var list = partialResult
            list.append(contentsOf: list)
            return list
            
        }
    }
    
    
    /// Gets an array with the first (X) elements in the array
    ///
    /// - Note: This function will **NOT** mutate the array.
    /// 
    /// - Parameter number: The number of elements you would like to keep. Must be greater or equal to 0
    /// - Returns: A copy of an array containing the array's first `number` values. If the array was already smalleer it returns the original array
    func keepFirst(_ number: Int) -> [Element] {
        
        var copy = self
        if self.count < number {
            return self
        }
        
        let numberToRemove = self.count - number
        
        copy.removeLast(numberToRemove)
        
        return copy
        
    }

    

}

//MARK: Gender Enum
enum Gender : String, Codable, CaseIterable {
    case man = "Male", woman = "Female"
}

extension Golfer {
    static var golfer: Golfer {
        var golfer = Golfer(firebaseID: "exampleID", gender: .man, name: "Logan")
        golfer.addRound(Round.emptyRoundExample1)
        
        return golfer
    }
}
