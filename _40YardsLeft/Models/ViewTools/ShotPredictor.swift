//
//  PredictedShot.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-28.
//

import Foundation

struct UserDistanceValues {
    /// The mininum distance that the user will lay up to
    ///
    /// - Note: This is a predicative measure which is not critical to app functionality
    let minimumApproachDistance: Double = 80
    
    /// The maximum distance the user will attempt to approach the green on.
    ///
    /// - Note: This is a predicative measure which is not critical to app functionality
    let maximumApproachDistance: Double = 240
    
    /// The usual drive distance of this user.
    ///
    /// - Note: This is a predicative measure which is not critical to app functionality
    let driveDistance: Double = 280
    
    
    /// The average proximity of a shot when attempting the green in feet.
    let averageProximity: Double = 33
    
    
    /// The average distance your recovery distance travels
    let averageRecoveryDistance: Double = 79
}

//MARK: Shot Predictor Class
class ShotPredictor {
    
    private let userDistanceValues: UserDistanceValues
    
    
    private static let DROP_PENALTY = 10.0
    
    private static let CHIP_CUTOFF = 50.0
    
    
    
    
    init(golfer: Golfer) {
        //TODO: Implement the getUsrPredictionsMethod in Golfer.
        let values = Self.getPresetsFromShots(shots: [])
        
    }
    
    private static func getPresetsFromShots(shots: [Shot]) -> (Double, Double, Double, Double, Double) {
        //TODO: Implement this method (and by that i mean call the method from the golfer.
        return (0, 0, 0, 0, 0)
    }

}

//MARK: Predictor Methods
extension ShotPredictor {
    //TODO: write this spec
    
    /// Gets the next predicted location from the provided position.
    ///
    /// The logic is as follows
    ///
    /// - Parameters:
    ///  - position: The position where the last shot has taken place from.
    ///  - par: The par of the hole which must be valid (between 3 and 5)
    ///
    /// - Returns: The predicted location of the next shot based on par
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
        
        
        return Position(lie: .fairway, yardage: .feet(userDistanceValues.averageProximity))
    }
    
    
    private func expectShotFromTee(distance: Distance) -> Position {
        if distance.yardage < userDistanceValues.maximumApproachDistance {
            return Position(lie: .green, yardage: Distance(feet: userDistanceValues.averageProximity))
        }
        
        let expectedYardage = Int(distance.yardage - self.userDistanceValues.driveDistance)
        
        if expectedYardage > Int(self.userDistanceValues.minimumApproachDistance) {
            return Position(lie: .fairway, yardage: Distance(yards: expectedYardage))
        }
        
        return Position(lie: .fairway, yardage: Distance(yards: Int(self.userDistanceValues.minimumApproachDistance)))
    }
    
    private func expectShotFromFairway(distance: Distance) -> Position {
        if distance.yardage < userDistanceValues.maximumApproachDistance {
            return Position(lie: .green, yardage: Distance(feet: userDistanceValues.averageProximity * 2 / 3))
        }
        
        let expectedYardage = Int(distance.yardage - self.userDistanceValues.driveDistance / 5 * 6)
        
        if expectedYardage > Int(userDistanceValues.minimumApproachDistance) {
            return Position(lie: .fairway, yardage: Distance(yards: expectedYardage))
        }
        
        return Position(lie: .fairway, yardage: Distance(yards: Int(userDistanceValues.minimumApproachDistance)))
    }
    
    private func expectShotFromRough(distance: Distance) -> Position {
        if distance.yardage < userDistanceValues.maximumApproachDistance {
            return Position(lie: .green, yardage: Distance(feet: userDistanceValues.averageProximity))
        }
        
        let expectedYardage = Int(distance.yardage - self.userDistanceValues.driveDistance / 5 * 6)
        
        if expectedYardage > Int(userDistanceValues.minimumApproachDistance) {
            return Position(lie: .fairway, yardage: Distance(yards: expectedYardage))
        }
        
        return Position(lie: .fairway, yardage: Distance(yards: Int(userDistanceValues.minimumApproachDistance)))
    }
    
    private func expectShotFromBunker(distance: Distance) -> Position {
        if distance.yardage < userDistanceValues.maximumApproachDistance / 4 * 5 {
            return Position(lie: .green, yardage: Distance(feet: userDistanceValues.averageProximity * 5 / 3))
        }
        
        let expectedYardage = Int(distance.yardage - self.userDistanceValues.driveDistance / 2 * 3)
        
        if expectedYardage > Int(userDistanceValues.minimumApproachDistance) {
            return Position(lie: .fairway, yardage: Distance(yards: expectedYardage))
        }
        
        return Position(lie: .fairway, yardage: Distance(yards: Int(userDistanceValues.minimumApproachDistance)))
    }
    
    private func expectShotFromPenalty(distance: Distance) -> Position {
        return Position(lie: .rough, yardage: .yards(distance.yardage + Self.DROP_PENALTY))
    }
    
    private func expectShotFromRecovery(distance: Distance) -> Position {
        let expectedYardage = distance.yardage - self.userDistanceValues.averageRecoveryDistance
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

//MARK: Shot Type Predictor
extension ShotPredictor {
    
    
    func getPredictedShot(position: Position, par: Int) -> ShotType {
        switch position.lie {
        case .tee:
            if par == 3 || position.yardage.yardage < self.userDistanceValues.maximumApproachDistance {
                return .approach
            }
            return .drive
        case .green:
            return .putt
        case .rough, .fairway, .bunker:
            if position.yardage.yardage > Self.CHIP_CUTOFF {
                return .approach
            }
            return .chip_pitch
        case .recovery:
            return .other
        case .penalty:
            return .other
        }
    }
    
    
}


