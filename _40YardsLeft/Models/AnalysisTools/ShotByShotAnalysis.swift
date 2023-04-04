//
//  ShotByShotAnalysis.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-04.
//

import Foundation

struct ShotByShot {
    static func getAverageDriveDistance(shots: [Shot]) -> Double {
        let driveDistance = shots
            .filter { $0.type == .drive }
            .map { $0.endPosition.yardage.yardage - $0.startPosition.yardage.yardage}
        //TODO: finish implementing this method
        
        return 0
            
    }
}

