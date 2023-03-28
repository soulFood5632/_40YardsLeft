//
//  PredictedShot.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-28.
//

import Foundation

struct ShotPredictor {
    static func predictedNextLocation(_ position: Position) -> Position {
        switch position.lie {
        case .tee:
            return expectShotFromTee(distance: position.yardage)
        default:
            return Position(lie: .bunker, yardage: Distance(yards: 10))
        }
    }
    
    private static func expectShotFromTee(distance: Distance) -> Position {
        return Position(lie: .fairway, yardage: Distance(yards: Int(distance.yardage) - 280))
    }
}
