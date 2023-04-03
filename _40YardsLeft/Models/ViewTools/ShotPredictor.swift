//
//  PredictedShot.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-28.
//

import Foundation

struct ShotPredictor {
    /// The mininum distance that the user will lay up to
    ///
    /// - Note: This is a predicative measure which is not critical to app functionality
    let minimumApproachDistance: Double
    
    /// The maximum distance the user will attempt to approach the green on.
    ///
    /// - Note: This is a predicative measure which is not critical to app functionality
    let maximumApproachDistance: Double
    
    /// The usual drive distance of this user.
    ///
    /// - Note: This is a predicative measure which is not critical to app functionality
    let driveDistance: Double
    
    
    /// The average proximity of a shot when attempting the green.
    let averageProximity: Double
    
    let averageRecoveryDistance: Double
    
    static let DROP_PENALTY = 10.0

}

//MARK: Shot Predictor
extension ShotPredictor {
    /// Gets the next predicted location from the provided position.
    ///
    /// - Parameters:
    ///  - position: The position where the last shot has taken place from.
    ///  - par: The par of the hole which must be valid (between 3 and 5)
    ///
    /// - Returns: The predicted location
    func predictedNextLocation(_ position: Position, par: Int) -> Position {
        switch position.lie {
        case .tee:
            precondition(par >= 3 && par <= 5)
            if par == 3 {
                return expectShotFromTeePar3(distance: position.yardage)
            }
            return expectShotFromTee(distance: position.yardage)
        case .fairway:
            return expectShotFromFairway(distance: position.yardage)
        case .rough:
            return expectShotFromRough(distance: position.yardage)
        case .penalty:
            return expectShotFromPenalty(distance: position.yardage)
        case .bunker:
            return expectShotFromBunker(distance: position.yardage)
        case .recovery:
            return expectShotFromRecovery(distance: position.yardage)
        case .green:
            return expectShotFromGreen(distance: position.yardage)
        }
    }
    
    private func expectShotFromTeePar3(distance: Distance) -> Position {
        
        
        return Position(lie: .fairway, yardage: .feet(averageProximity))
    }
    
    
    private func expectShotFromTee(distance: Distance) -> Position {
        if distance.yardage < maximumApproachDistance {
            return Position(lie: .green, yardage: Distance(feet: averageProximity))
        }
        
        let expectedYardage = Int(distance.yardage - self.driveDistance)
        
        if expectedYardage > Int(self.minimumApproachDistance) {
            return Position(lie: .fairway, yardage: Distance(yards: expectedYardage))
        }
        
        return Position(lie: .fairway, yardage: Distance(yards: Int(self.minimumApproachDistance)))
    }
    
    private func expectShotFromFairway(distance: Distance) -> Position {
        if distance.yardage < maximumApproachDistance {
            return Position(lie: .green, yardage: Distance(feet: averageProximity * 2 / 3))
        }
        
        let expectedYardage = Int(distance.yardage - self.driveDistance / 5 * 6)
        
        if expectedYardage > Int(minimumApproachDistance) {
            return Position(lie: .fairway, yardage: Distance(yards: expectedYardage))
        }
        
        return Position(lie: .fairway, yardage: Distance(yards: Int(minimumApproachDistance)))
    }
    
    private func expectShotFromRough(distance: Distance) -> Position {
        if distance.yardage < maximumApproachDistance {
            return Position(lie: .green, yardage: Distance(feet: averageProximity))
        }
        
        let expectedYardage = Int(distance.yardage - self.driveDistance / 5 * 6)
        
        if expectedYardage > Int(minimumApproachDistance) {
            return Position(lie: .fairway, yardage: Distance(yards: expectedYardage))
        }
        
        return Position(lie: .fairway, yardage: Distance(yards: Int(minimumApproachDistance)))
    }
    
    private func expectShotFromBunker(distance: Distance) -> Position {
        if distance.yardage < maximumApproachDistance / 4 * 5 {
            return Position(lie: .green, yardage: Distance(feet: averageProximity * 5 / 3))
        }
        
        let expectedYardage = Int(distance.yardage - self.driveDistance / 2 * 3)
        
        if expectedYardage > Int(minimumApproachDistance) {
            return Position(lie: .fairway, yardage: Distance(yards: expectedYardage))
        }
        
        return Position(lie: .fairway, yardage: Distance(yards: Int(minimumApproachDistance)))
    }
    
    private func expectShotFromPenalty(distance: Distance) -> Position {
        return Position(lie: .rough, yardage: .yards(distance.yardage + Self.DROP_PENALTY))
    }
    
    private func expectShotFromRecovery(distance: Distance) -> Position {
        let expectedYardage = distance.yardage - self.averageRecoveryDistance
        if expectedYardage > 30 {
            return Position(lie: .fairway, yardage: .yards(expectedYardage))
        }
        
        return Position(lie: .rough, yardage: .yards(expectedYardage))
    }
    
    private func expectShotFromGreen(distance: Distance) -> Position {
        if distance.feet > 30 {
            return Position(lie: .green, yardage: .feet(2))
        }
        return .holed
    }
}
