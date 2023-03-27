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

//MARK: ShotType Enum
enum ShotType : String, Codable {
    case drive, approach, chip_pitch, putt, penalty
}
