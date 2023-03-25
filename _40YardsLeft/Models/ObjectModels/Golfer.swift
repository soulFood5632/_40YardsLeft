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
    let gender : Gender
    
    init(firebaseID: String, gender: Gender) {
        self.firebaseID = firebaseID
        self.rounds = [Round]()
        self.gender = gender
    }
    
    mutating func addRound(_ round : Round) -> Bool {
        if self.rounds.contains(round) {
            return false
        }
        
        self.rounds.append(round)
        return true
    }

}

enum Gender : String , Codable {
    case man, woman
}
