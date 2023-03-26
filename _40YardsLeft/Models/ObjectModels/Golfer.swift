//
//  Golfer.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-25.
//

import Foundation
import Firebase

struct Golfer : Codable, Equatable {
    
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
    
    mutating func addRound(_ round : Round) -> Bool {
        if self.rounds.contains(round) {
            return false
        }
        
        self.rounds.append(round)
        return true
    }

}

enum Gender : String, Codable, CaseIterable {
    case man = "Male", woman = "Female"
}
