//
//  ShotFilters.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-05-14.
//

import Foundation

/// A set of static methods which are used to filter shots.
struct ShotFilters {
    
    /// Includes all shots of type `.approach`
    static let allApproach: (Shot) -> Bool = { $0.type == .approach }
    ///Includes all shots of type `chip_pitch`
    static let allShortGame: (Shot) -> Bool = { $0.type == .chip_pitch }
    
    static let allPutts: (Shot) -> Bool = { $0.type == .putt }
    
    static let allTeeShots: (Shot) -> Bool = { $0.type == .drive }
    
    static let allOther: (Shot) -> Bool = { $0.type == .other }
    
    static let bunkerShortGame: (Shot) -> Bool = { allShortGame($0) && $0.startPosition.lie == .bunker }
    
    static let roughShortGame: (Shot) -> Bool = { allShortGame($0) && $0.startPosition.lie == .rough }
}
