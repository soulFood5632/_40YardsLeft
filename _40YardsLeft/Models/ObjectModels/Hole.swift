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
