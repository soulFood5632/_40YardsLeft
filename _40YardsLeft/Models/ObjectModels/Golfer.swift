//
//  Golfer.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-25.
//

import Foundation


class Golfer: Codable, ObservableObject {
    private static let MINUMUM_SHOTS_FOR_ANALYSIS = 1000
    
    let firebaseID: String
    @Published private(set) var rounds: [Round]
    @Published var gender : Gender
    @Published var name : String
    @Published var homeCourse : Course?
    
    init(firebaseID: String, gender: Gender, name: String ) {
        self.firebaseID = firebaseID
        self.rounds = [Round]()
        self.gender = gender
        self.name = name
        //TODO: add home course. once courses have been added to populate things
    }
    
    required init(from decoder: Decoder) throws {
        let storage = try decoder.container(keyedBy: Keys.self)
        self.firebaseID = try storage.decode(String.self, forKey: .id)
        self.rounds = try storage.decode([Round].self, forKey: .rounds)
        self.gender = try storage.decode(Gender.self, forKey: .gender)
        self.name = try storage.decode(String.self, forKey: .name)
        self.homeCourse = try storage.decodeIfPresent(Course.self, forKey: .homeCourse)
    }
    
    public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: Keys.self)
        try values.encode(self.firebaseID, forKey: .id)
        try values.encode(self.rounds, forKey: .rounds)
        try values.encode(self.gender, forKey: .gender)
        try values.encode(self.name, forKey: .name)
        try values.encode(self.homeCourse, forKey: .homeCourse)
    }
    
    
    /// Keys used to encode and decode course objects.
    private enum Keys: CodingKey {
        case id
        case rounds
        case gender
        case name
        case homeCourse
    }
    
    

}

extension Golfer: Equatable {
    static func == (lhs: Golfer, rhs: Golfer) -> Bool {
        lhs.firebaseID == rhs.firebaseID
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
    
    @discardableResult
    /// Adds the given round to this golfer.
    ///
    /// - Parameter round: The round you would like to add
    /// - Returns: False if the round already has been added, true if succseful.
    func addRound(_ round : Round) -> Bool {
        if self.rounds.contains(round) {
            return false
        }
        
        self.rounds.append(round)
        return true
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
        return Array.combine(arrays: self.rounds.map { $0.getShots })
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
    static var golfer: Golfer { Golfer(firebaseID: "exampleID", gender: .man, name: "Logan") }
}
