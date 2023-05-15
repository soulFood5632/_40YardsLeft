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
    
    //MARK: Best Fit Model Coeffecents
    
    //TODO: think about the bounds here.
    
    
    /// A dictionary containing a lie to polynomial coeffeincents
    ///
    /// The polynomial coeffeicents are stroed as follows. Each index refers to the multiplicty of the input variable to multiplied by the provided value.
    ///
    /// The bounds for the curves are listed
    private static let POLYNOMIAL_COEF: [Lie: [Double]] = [
        .fairway: [1.96230225,
                   2.68710064 * pow(10, -2.0),
                   -3.44863299 * pow(10, -4.0),
                   1.88990234 * pow(10, -6.0),
                   -1.33867879 * pow(10, -9.0),
                   -2.63718048 * pow(10, -11.0),
                   1.16912702 * pow(10, -13.0),
                   -2.21876716 * pow(10, -16.0),
                   2.05009648 * pow(10, -19.0),
                   -7.54163032 * pow(10, -23.0)],
        .rough: Self.ROUGH_POLY,
        .recovery: RECOVERY_POLY,
        .green: [1.0], //TODO: later
        .bunker: BUNKER_POLY,
        .tee: TEE_POLY,
        
    ]
    
    
    private static let ROUGH_POLY: [Double] = [-2.30555100 * pow(10, -20.0),
                                      6.82301116 * pow(10, -17.0),
                                      -8.37048179 * pow(10, -14.0),
                                      5.49444277 * pow(10, -11.0),
                                      -2.07592593 * pow(10, -8.0),
                                      4.51396604 * pow(10, -6.0),
                                      -5.31788250 * pow(10, -4.0),
                                      3.35009075 * pow(10, -2.0),
                                      2.06875521].reversed()
    
    private static let RECOVERY_POLY: [Double] = [1.85148615 * pow(10, -29.0),
                                                -7.89763132 * pow(10, -26.0),
                                                1.48410958 * pow(10, -22.0),
                                                -1.61553778 * pow(10, -19.0),
                                                1.12662901 * pow(10, -16.0),
                                                -5.25535540 * pow(10, -14.0),
                                                1.66183732 * pow(10, -11.0),
                                                -3.53231470 * pow(10, -9.0),
                                                4.89003330 * pow(10, -7.0),
                                                -4.12307734 * pow(10, -5.0),
                                                1.83821301 * pow(10, -3.0),
                                                -2.85516123 * pow(10, -2.0),
                                                3.59132793].reversed()
    
    private static let BUNKER_POLY: [Double] = [4.18966970 * pow(10, -24.0),
                                                -1.35433526 * pow(10, -20.0),
                                                1.87643888 * pow(10, -17.0),
                                                -1.45351465 * pow(10, -14.0),
                                                6.88157540 * pow(10, -12.0),
                                                -2.04294784 * pow(10, -9.0),
                                                3.74606781 * pow(10, -7.0),
                                                -3.99887378 * pow(10, -5.0),
                                                2.17007360 * pow(10, -3.0),
                                                -3.75607642 * pow(10, -2.0),
                                                2.64362841].reversed()
    
    private static let TEE_POLY: [Double] = [-3.75282818 * pow(10, -22.0),
                                              1.27985157 * pow(10, -18.0),
                                              -1.84388419 * pow(10, -15.0),
                                              1.46018139 * pow(10, -12.0),
                                              -6.93158896 * pow(10, -10.0),
                                              2.02079110 * pow(10, -7.0),
                                              -3.57254342 * pow(10, -5.0),
                                              3.66178146 * pow(10, -3.0),
                                              -1.94968196 * pow(10, -1.0),
                                              6.96395117].reversed()
    
    
    

    /// Two positions are equal if their lies and yardage are both equal to each other.
    static func == (lhs: Position, rhs: Position) -> Bool {
        
        
        return lhs.lie == rhs.lie && lhs.yardage == rhs.yardage
    }
}



//MARK: Expected strokes to hole out swift.
extension Position {
    /// Gets the expected strokes to hole out from this position.
    ///
    /// This value is determined using a model which takes in pga tour data for the expected strokes to hole out from the given location. Each lie type will have a different calculation.
    ///
    /// - Note: If the given shot is from the tee but less than 100 yards, the approach formula will be used.
    ///
    /// - Throws: `ExpectedStrokes.noDataForLie` if the given lie does not have a valid strokes gained value.
    ///
    /// - Returns: A double representing the expected strokes to hole out from this position.
    func getExpectedStrokes() throws -> Double {
        
        // if the tee shot is less than 100 then we will use fairway
        var lie = self.lie
        if lie == .tee && yardage < .yards(100) {
            lie = .fairway
        }
        guard let coeffecients = Self.POLYNOMIAL_COEF[lie] else {
            throw ExpectedStrokes.noDataForLie
        }
        

        var value = Double(0)
        for index in coeffecients.indices {
            value += pow(self.yardage.yards, Double(index)) * coeffecients[index]
        }
        return value
        
    }
    
    
}

//MARK: Expected shot type
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
            
            if yardage.yards >= 250 {
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

//MARK: Static stored positions
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




