//
//  Hole.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-25.
//

import Foundation

struct Hole : Codable, Equatable {
    
    let holeData: HoleData
    var shots: [Shot] = [Shot]()
    
    
    /// Gets the staring position of this hole.
    ///
    /// - Returns: A position which starts on the tee at the provided starting distance. 
    func getStartPosition() -> Position {
        return Position(lie: .tee, yardage: holeData.yardage)
    }
    
    
    
}

extension Hole {
    var isComplete: Bool {
        if shots.isEmpty {
            return false
        }
        
        return isHoled()
        
        
    }
    
    
    /// Finds if the last shot has was holed
    ///
    /// - Requires: The shot list must not be empty
    ///
    /// - Returns: True if the last shot was holed, false otherwise
    private func isHoled() -> Bool {
        precondition(!shots.isEmpty)
        
        return shots.last!.endPosition == .holed
    }
}
