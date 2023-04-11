//
//  Hole.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-25.
//

import Foundation
import SwiftUI

//MARK: Hole Init
struct Hole : Codable, Equatable {
    
    //TODO: write RI's and AF.
    
    let holeData: HoleData
    private(set) var shots: [Shot] {
        didSet {
            if isHoled() {
                self.populateSimplifiedShot()
            }
        }
    }
    
    init(holeData: HoleData) {
        self.holeData = holeData
        self.shots = [Shot]()
    }
    
    private var simplifiedShotsCache: [Shot]? = nil
    
//TODO: investigate thread safety of this mechanism, maybe encase things in nil. not sure
    private mutating func populateSimplifiedShot() {
        self.simplifiedShotsCache = self.getCombinedShots()
    }
    
    
    /// Gets the simplified shot form that does not include penatlties
    ///
    /// - Requires: The shot list is complete (it is holed)
    /// - Returns: A list containing a collection of all shots where all shots that end in a pentatly are joined with the next shot's end position.
    private func getCombinedShots() -> [Shot] {
        var shotList = [Shot]()
        var index = 0
        precondition(self.isComplete)
        while true {
            // it should not be possible for this to be the case. The first shot must not be a penatly, all penalties should have been handled at this point.
            precondition(shots[index].startPosition.lie != .penalty)
            
            //if the last shot is holed then we can conclude that this list is done
            if shots[index].isHoled {
                shotList.append(shots[index])
                break
            }
            
            // if the end of this shot is a penatly we will need to combine things to have a shot that includes a penalty.
            if shots[index].endPosition.lie == .penalty {
                let newShot = Shot(type: shots[index].type,
                                   startPosition: shots[index].startPosition,
                                   endPosition: shots[index].endPosition,
                                   includesPenalty: true)
                
                shotList.append(newShot)
                index += 2
                continue
            }
            
            shotList.append(shots[index])
            index += 1
            
        }
        return shotList
        
    }
    
    
}

//MARK: Shot Entry Helpers
extension Hole {
    mutating func addShot(_ shot: Shot) {
        shots.append(shot)
    }
    
    mutating func addShots(_ shots: [Shot]) {
        self.shots.append(contentsOf: shots)
    }
    
    mutating func resetShots() {
        shots.removeAll()
    }
    
    @discardableResult
    /// Removes the given shot from the hole
    /// 
    /// - Parameter shot: The shot you would like to remove
    /// - Returns: <#description#>
    mutating func removeShot(_ shot: Shot) -> Bool {
        if shots.contains(shot) {
            shots.removeAll{ $0 == shot }
            return true
        }
        return false
    }
}

//MARK: Hole Stored Values
extension Hole {
    
    /// Is the hole complete (has the last shot been holed)
    var isComplete: Bool {
        if shots.isEmpty {
            return false
        }
        
        return isHoled()
    }
    
    
    /// The score of the hole
    var score: Int { self.shots.count }
    
    /// The score of the hole to par.
    var scoreToPar: Int { score - holeData.par }
    
    
    /// Gets a list of the the simplified shots
    ///
    /// - Use this list for any data analysis with strokes gained. The elimination of penalties will allow for easier analysis.
    ///
    /// - Throws: `ShotGeneration.holeNotComplete` if the hole is not complete and therefore does not contain a valid shotSimplification
    /// - Returns: A list of shots which do not contain any positions of a lie penatly
    func getSimplifiedShots() throws -> [Shot] {
        if let simplifiedShotsCache {
            return simplifiedShotsCache
        }
        
        throw ShotGeneration.holeNotComplete
    }
    
    /// Gets the staring position of this hole.
    ///
    /// - Returns: A position which starts on the tee at the provided starting distance.
    func getStartPosition() -> Position {
        return Position(lie: .tee, yardage: holeData.yardage)
    }
    
    
    
    
    /// Gets a colour from the score to par.
    ///
    /// - Parameter score: The score to par of the hole you would like to get the colour of
    /// - Returns: blue for a par, red for under par, black for over par.
    func getColourFromScore(scoreToPar: Int) -> Color {
        if score == 0 {
            return .blue
        }
        if score < 0 {
            return .red
        }
        
        return .black
    }
    

    
    
    /// Finds if the last shot has was holed
    ///
    /// - Requires: The shot list must not be empty
    ///
    /// - Returns: True if the last shot was holed, false otherwise
    private func isHoled() -> Bool {
        precondition(!shots.isEmpty)
        
        return shots.last!.endPosition == .holed
    }
}

//MARK: Shot Generation Error
enum ShotGeneration: Error {
    case holeNotComplete
}
