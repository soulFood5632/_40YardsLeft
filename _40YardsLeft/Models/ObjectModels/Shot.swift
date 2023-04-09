//
//  Shot.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-25.
//

import Foundation

struct Shot : Codable, Equatable {
    
    
    let type: ShotType
    let startPosition: Position
    let endPosition: Position
    //TODO: add club??
}

extension Shot {
    var advancementYardage: Distance { endPosition.yardage - startPosition.yardage }
}

//MARK: ShotType Enum
enum ShotType : String, Codable, CaseIterable {
    case drive = "Drive"
    case approach = "Approach"
    case chip_pitch = "Chip/Pitch"
    case putt = "Putt"
    case penalty = "Penalty"
    case other = "Other"
}
