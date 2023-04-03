//
//  PredictedShot.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-28.
//

import Foundation

struct ShotPredictor {
    
    let driveDistance: Int

    func predictedNextLocation(_ position: Position) -> Position {
        switch position.lie {
        case .tee:
            return expectShotFromTee(distance: position.yardage)
        default:
            return Position(lie: .bunker, yardage: Distance(yards: 10))
        }
    }
    
    
    private func expectShotFromTee(distance: Distance) -> Position {
        if distance.yardage < 250 {
            return Position(lie: .green, yardage: Distance(feet: 35))
        }
        
        let expectedYardage = Int(distance.yardage) - self.driveDistance
        
        if expectedYardage > 90 {
            return Position(lie: .fairway, yardage: Distance(yards: expectedYardage))
        }
        
        return Position(lie: .fairway, yardage: Distance(yards: 90))
    }
    
    
    
}
