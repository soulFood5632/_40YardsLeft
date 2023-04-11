//
//  Shot.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-25.
//

import Foundation

//MARK: Shot Init
struct Shot : Codable, Equatable {
    
    
    let type: ShotType
    let startPosition: Position
    let endPosition: Position
    //Does this shot include a penatly stroke.
    let includesPenalty: Bool
    
    
    /// The strokes gained of this shot if it is calculatable.
    ///
    /// If one of either the start or end position is of the lie penatly, then there will be no way to tell this value so it is nil.
    let strokesGained: Double?
    
    init(type: ShotType, startPosition: Position, endPosition: Position, includesPenalty: Bool) {
        self.type = type
        self.startPosition = startPosition
        self.endPosition = endPosition
        self.includesPenalty = includesPenalty
        do {
            self.strokesGained = try Self.getStrokesGained(start: startPosition, end: endPosition, includesPenalty: includesPenalty)
        } catch {
            self.strokesGained = nil
        }
    }
    
    init(type: ShotType, startPosition: Position, endPosition: Position) {
        self.type = type
        self.startPosition = startPosition
        self.endPosition = endPosition
        self.includesPenalty = false
        do {
            self.strokesGained = try Self.getStrokesGained(start: startPosition, end: endPosition, includesPenalty: false)
        } catch {
            self.strokesGained = nil
        }
    }
    
    
    /// Gets the strokes gained from the start
    ///
    /// - Parameters:
    ///   - start: The start position of this shot.
    ///   - end: The end position of this shot
    ///   - includesPenalty: Whether or not this shot includes a penalty stroke
    /// - Returns: A double containing the strokes gained value of the shot
    private static func getStrokesGained(start: Position, end: Position, includesPenalty: Bool) throws -> Double {
        if includesPenalty {
            return try start.getExpectedStrokes() - end.getExpectedStrokes() - 2
        }
        return try start.getExpectedStrokes() - end.getExpectedStrokes() - 1
    }
    
}


//MARK: Shot computed values.
extension Shot {
    var advancementYardage: Distance { endPosition.yardage - startPosition.yardage }
    /// The number of shots that this shot has counted for. 
    var numOfShots: Int {
        if includesPenalty {
            return 2
        }
        return 1
    }
    
    var isHoled: Bool { return endPosition == .holed } 
    
    
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
