//
//  Position.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-25.
//

import Foundation

//MARK: Position Struct

/// A location on the golf course containing its distance to the hole and its lie.
///
/// From this position you
struct Position : Codable, Hashable {
    
    /// The lie of the position
    var lie: Lie
    /// The yardage of this position from the ball to the hole.
    var yardage: Distance
    
    
    /// Gets the expected strokes to hole out from this position.
    ///
    /// - Returns: A double representing the expected strokes to hole out from this position.
    func getExpectedStrokes() throws -> Double {
        switch self.lie {
        case .penalty:
            throw ExpectedStrokes.noDataForLie
        default:
            return 1.0
        }
    }
    
    
    /// Two positions are equal if their lies and yardage are both equal to each other.
    static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.lie == rhs.lie && lhs.yardage == rhs.yardage
    }
}

extension Position {
    
    /// Gets the expected shot type from this position
    /// - Returns: A predicted shot type from the position. 
    func expectedShotType() -> ShotIntermediate.ShotDeclaration {
        switch self.lie {
        case .tee:
            if yardage.yards > 250 {
                return .drive
            }
            
            return .atHole
        case .fairway, .bunker, .rough:
            
            if yardage.yards > 250 {
                return .other
            }
            return .atHole
            
        case .penalty:
            return .drop
        case .recovery:
            return .other
        case .green:
            return .atHole
        }
    
    }
}

/// A set of errors used to communicate when expected strokes cannot be calculated.
enum ExpectedStrokes : Error {
    case noDataForLie
}

extension Position {
    
    /// The ball is holed out.
    static let holed = Position(lie: .green, yardage: .zero)
}

//MARK: Lie Enum
/// A set of values which house the valid lie types on a golf course
enum Lie : String, Codable, Hashable, CaseIterable {
    
    case fairway = "Fairway"
    case rough = "Rough"
    case tee = "Tee"
    case bunker = "Sand"
    case penalty = "Penalty"
    case recovery = "Recovery"
    case green = "Green"
}


extension Lie : Identifiable {
    var id: Self { self }
}

//MARK: Distance Struct

/// A distance which contains a unit independant distance value.
///
/// You can instansiate a distance object by inputting the value in yards, meters, or feet.
struct Distance : Codable, Hashable {
    /// The distance value in yards
    var yards: Double
    ///The distance value in feet
    var feet: Double {
        get {
            self.yards * Self.FEET_IN_A_YARD
        } set {
            self.yards = newValue / Self.FEET_IN_A_YARD
        }
    }
    /// the distance value in meters
    var meters: Double {
        get {
            self.yards * Self.METERS_IN_A_YARD
        } set {
            self.yards = newValue / Self.METERS_IN_A_YARD
        }
    }
    
    private static let METERS_IN_A_YARD = 1.09361
    private static let FEET_IN_A_YARD: Double = 3
    ///Creates a new instance of a distance from yards
    init(yards: Int) {
        self.yards = Double(yards)
    }
    
    /// Creates a new instance of distance from yards
    init(yards: Double) {
        self.yards = yards
    }
    
    /// Creates a new distance instance from meters
    ///
    /// - Parameter meters: The number of meters you would like to
    init(meters: Int) {
        self.yards = Double(meters) / Self.METERS_IN_A_YARD
    }
    
    /// Creates a new distance from meters
    init(meters: Double) {
        self.yards = meters / Self.METERS_IN_A_YARD
    }
    
    init(feet: Int) {
        self.yards = Double(feet) / Self.FEET_IN_A_YARD
    }
    
    init(feet: Double) {
        self.yards = feet / Self.FEET_IN_A_YARD
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
    ///
    /// - Parameter factor: A double represnting the factor by which you are looking to scale the distance by.
    /// - Returns: A distance containing the new scaled value
    func scaleBy(_ factor: Double) -> Distance {
        return .yards(self.yards * factor)
    }
    

}



