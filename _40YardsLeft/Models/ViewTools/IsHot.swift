//
//  IsHot.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-13.
//

import Foundation

struct IsHot {
    
    
    /// Finds if the number of rounds played in the last set of days is within the provided thresholds.
    ///
    /// - Requires: `hotThreshold` > `coldThreshold`
    ///
    /// - Parameters:
    ///   - rounds: The number of rounds played
    ///   - days: The number of days that these rounds occured within
    ///   - hotThreshold: The threshold value of rounds per day where the golfer is considered on a hot streak
    ///   - coldTreshold: The threshold value of rounds per day where the golfer is consider on a cold streak
    /// - Returns: The value of three state that corresponds to its position within the provided bounds
    static func numOfRounds(rounds: Int, days: Int, hotThreshold: Double, coldThreshold: Double) -> ThreeState {
        precondition(hotThreshold > coldThreshold)
        let roundsPerDay = Double(rounds) / Double(days)
        if roundsPerDay > hotThreshold {
            return .hot
        } else if roundsPerDay < coldThreshold {
            return .cold
        }
        
        return .mild
    }
    
 
}
