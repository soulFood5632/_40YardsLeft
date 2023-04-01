//
//  Position.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-25.
//

import Foundation

//MARK: Position Struct

struct Position : Codable, Equatable {
    
    var lie: Lie
    var yardage: Distance
    
    
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

extension Position {
    static let holed = Position(lie: .green, yardage: .zero)
}

//MARK: Lie Enum
enum Lie : String, Codable, Equatable, CaseIterable, Identifiable {
    
    case fairway = "Fairway"
    case rough = "Rough"
    case tee = "Tee"
    case bunker = "Sand"
    case penalty = "Penalty"
    case recovery = "Recovery"
    case green = "Green"
}

extension Lie {
    var id: Self { self }
}

//MARK: Distance Struct

/// <#Description#>
struct Distance : Codable, Equatable {
    var yardage: Double
    
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
    
    static func meters(_ meters: Int) -> Distance {
        return self.init(meters: meters)
    }
    
    static func yards(_ yards: Int) -> Distance {
        return self.init(yards: yards)
    }
    
    static func feet(_ feet: Int) -> Distance {
        return self.init(feet: feet)
    }
}

extension Distance {
    static let zero = Distance(yards: 0)
}


