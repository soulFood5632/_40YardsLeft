//
//  Position.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-25.
//

import Foundation

//MARK: Position Struct

struct Position : Codable, Equatable {
    
    let lie: Lie
    let yardage: Distance
    
    
    /// Gets the expected strokes to hole out from this position.
    ///
    /// - Returns: A double representing the expected strokes to hole out from this position.
    func getExpectedStrokes() -> Double {
        //TODO: write this method. 
        return 1
    }
    static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.lie == rhs.lie && lhs.yardage == rhs.yardage
    }
}

//MARK: Lie Enum
enum Lie : String, Codable, Equatable {
    case fairway, rough, tee, bunker, penalty, recovery, green
}

//MARK: Distance Struct

/// <#Description#>
struct Distance : Codable, Equatable {
    public let yardage: Double
    
    private static let METERS_IN_A_YARD = 1.09361
    private static let FEET_IN_A_YARD = 3
    
    init(yards: Int) {
        self.yardage = Double(yards)
    }
    
    /// Creates a new distance instance from meters
    ///
    /// - Parameter meters: The number of meters you would like to
    init(meters: Int) {
        self.yardage = Double(meters) * Self.METERS_IN_A_YARD
    }
    
    init(feet: Int) {
        self.yardage = Double(feet * Self.FEET_IN_A_YARD)
    }
}


