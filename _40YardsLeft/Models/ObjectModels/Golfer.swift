//
//  Golfer.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-25.
//

import Foundation


struct Golfer : Codable, Equatable {
    
    private static let MINUMUM_SHOTS_FOR_ANALYSIS = 1000
    
    let firebaseID: String
    private(set) var rounds: [Round]
    var gender : Gender
    var name : String
    var homeCourse : Course?
    
    init(firebaseID: String, gender: Gender, name: String ) {
        self.firebaseID = firebaseID
        self.rounds = [Round]()
        self.gender = gender
        self.name = name
        //TODO: add home course. once courses have been added to populate things
    }
    
    

}

extension Golfer {
    var handicap: Double { return 0
        //TODO: Imploment this function
    }
    
    mutating func addRound(_ round : Round) -> Bool {
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
        var userValues = UserDistanceValues()
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
    static func combine(arrays: [[Element]]) -> [Element] {
        arrays.reduce([Element]()) { partialResult, list in
            var list = partialResult
            list.append(contentsOf: list)
            return list
            
        }
    }
}

enum Gender : String, Codable, CaseIterable {
    case man = "Male", woman = "Female"
}

extension Golfer {
    static var golfer: Golfer { Golfer(firebaseID: "exampleID", gender: .man, name: "Logan") }
}
