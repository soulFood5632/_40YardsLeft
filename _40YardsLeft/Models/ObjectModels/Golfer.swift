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
    
    func getLastRounds(_ number: Int) -> [Round] {
        self.rounds.sorted { round1, round2 in
            round1.date > round2.date
        }
        .removeAfter(number)
    }
    
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

extension Array {
    
    /// Combines the provided arrays into a single array.
    ///
    /// The new array will be ordered in such a way that the first array will be added to the array followed by the values in the next array.
    ///
    /// - Parameter arrays: A list of arrays of the same type which are to be combined.
    /// - Returns: <#description#>
    static func combine(arrays: [[Element]]) -> [Element] {
        arrays.reduce([Element]()) { partialResult, list in
            var list = partialResult
            list.append(contentsOf: list)
            return list
            
        }
    }
    
    func removeAfter(_ index: Int) -> [Element] {
        
        var copy = self
        if self.count < index {
            return self
        }
        
        let numberToRemove = self.count - index
        
        copy.removeLast(numberToRemove)
        
        return copy
        
    }

    

}

enum Gender : String, Codable, CaseIterable {
    case man = "Male", woman = "Female"
}

extension Golfer {
    static var golfer: Golfer { Golfer(firebaseID: "exampleID", gender: .man, name: "Logan") }
}
