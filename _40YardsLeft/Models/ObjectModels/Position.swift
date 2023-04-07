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
struct Distance : Codable {
    /// The distance value in yards
    var yards: Double
    ///The distance value in feet
    var feet: Double { self.yards * Self.FEET_IN_A_YARD }
    /// the distance value in meters
    var meters: Double { self.yards * Self.METERS_IN_A_YARD }
    
    private static let METERS_IN_A_YARD = 1.09361
    private static let FEET_IN_A_YARD: Double = 3
    
    init(yards: Int) {
        self.yards = Double(yards)
    }
    
    init(yards: Double) {
        self.yards = yards
    }
    
    /// Creates a new distance instance from meters
    ///
    /// - Parameter meters: The number of meters you would like to
    init(meters: Int) {
        self.yards = Double(meters) * Self.METERS_IN_A_YARD
    }
    
    init(meters: Double) {
        self.yards = meters * Self.METERS_IN_A_YARD
    }
    
    init(feet: Int) {
        self.yards = Double(feet) * Self.FEET_IN_A_YARD
    }
    
    init(feet: Double) {
        self.yards = feet * Self.FEET_IN_A_YARD
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
    
    static func meters(_ meters: Double) -> Distance {
        return self.init(meters: meters)
    }
    
    static func yards(_ yards: Double) -> Distance {
        return self.init(yards: yards)
    }
    
    static func feet(_ feet: Double) -> Distance {
        return self.init(feet: feet)
    }
    
}

//MARK: Distance -> default properties
extension Distance {
    static let zero = Distance(yards: 0)
    
}
//MARK: Distance Operators
extension Distance : AdditiveArithmetic {
    static func + (rhs: Distance, lhs: Distance) -> Distance {
        return .yards(rhs.yards + lhs.yards)
    }
    
    static func - (rhs: Distance, lhs: Distance) -> Distance {
        return .yards(rhs.yards - lhs.yards)
    }
    
}
//MARK: Distance equatable implomentation
extension Distance: Equatable {
    static func == (lhs: Distance, rhs: Distance) -> Bool {
        return lhs.yards == rhs.yards
    }
}
//MARK: Distance Comparable Implemention
extension Distance: Comparable {
    static func < (lhs: Distance, rhs: Distance) -> Bool {
        return lhs.yards < rhs.yards
    }
    
    
}

//MARK: Distance Methods
extension Distance {
    
    /// Multiples/scales the current distance by the provided factor.
    /// - Parameter factor: A double represnting the factor by which you are looking to scale the distance by.
    /// - Returns: A distance containing the new scaled value
    func scaleBy(_ factor: Double) -> Distance {
        return .yards(self.yards * factor)
    }
    

}



