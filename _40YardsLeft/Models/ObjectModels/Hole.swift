//
//  Hole.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-25.
//

import Foundation
import SwiftUI

//MARK: Hole Init
struct Hole: Codable, Equatable, Identifiable {
    
    //TODO: write RI's and AF.
    /// Basic information about the given hole. 
    let holeData: HoleData
    ///A Unique identifier for this hole.
    let id: UUID
    
    /// A list containg the shots that this hole has.
    ///
    /// After change of the list, if the hole is complete then it will populate the simplified shot cache. If the hole is no longer complete then it will reset the cache to nil.
    private var shots: [Shot] {
        didSet {
            if isComplete {
                self.simplifiedShotsCache = self.getCombinedShots()
            } else {
                self.simplifiedShotsCache = nil
            }
        }
    }
    
    
    /// Creates a new instance of hole with no shots.
    ///
    /// - Parameter holeData: A description of the hole.
    init(holeData: HoleData) {
        self.id = UUID()
        self.holeData = holeData
        self.shots = [Shot]()
    }
    
    /// A cache contaiing the shots which have been simplified to remove penalties.
    ///
    /// The cache will be defined if the hole is complete, false otherwise.
    private var simplifiedShotsCache: [Shot]? = nil
    
    
    
    /// Gets the simplified shot form that does not include penatlties
    ///
    /// - Requires: The shot list is complete (it is holed)
    ///
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
            
            // else it is simple as adding the shot to the end and advancing one.
            
            shotList.append(shots[index])
            index += 1
            
        }
        return shotList
        
    }
    
    
}

//MARK: Shot Entry Helpers
extension Hole {
    
    @discardableResult
    /// Adds the given shot to the hole.
    ///
    /// - Note: The shot to be added's start is the same position as the last shot. If there is no previous shot then there is no condition.
    ///
    /// - Parameter shot: The shot to be added (see preconditions)
    /// - Returns: True if the shot was succsefully added, false if
    mutating func addShot(_ shot: Shot) -> Bool {
        if let lastPosition = self.shots.last?.endPosition {
            if lastPosition != shot.startPosition {
                return false
            }
            // return false if the start position does not equal the end position
        }
        shots.append(shot)
        return true
        
    }
    
    @discardableResult
    /// Adds the given list of shots to the hole.
    ///
    /// - Important: The list must be ordered in sequence starting from the most first shot to the last shot.
    /// - Important: Each shot's finish must be equal to next shots start.
    /// - Important: The first shot in the list start must be equal to the last shot in this holes end position. If there is no shots in this hole then it doesn't matter the start.
    ///
    /// - Note: If one shot fails then the next shots will not be able to chain off of it. An early failure could cause all to fail.
    ///
    /// - Parameter shots: The list of shots to be added (see details in `Important` documentation)
    /// - Returns: A list of booleans which map the success of each index of the shots added to their individual success.
    mutating func addShots(_ shots: [Shot]) -> [Bool] {
        var returnArray = [Bool]()
        shots.forEach { shot in
            returnArray.append(self.addShot(shot))
        }
        return returnArray
    }
    
    
    /// Removes all shots from the hole.
    ///
    /// - Important: There is no reset after calling this function
    mutating func resetShots() {
        shots.removeAll()
    }
    
    @discardableResult
    /// Removes the given shot from the hole
    /// 
    /// - Parameter shot: The shot you would like to remove
    /// - Returns: True if the the shot was succsefully removed. False otherwise
    mutating func removeShot(_ shot: Shot) -> Bool {
        if shots.contains(shot) {
            shots.removeAll{ $0 == shot }
            return true
        }
        return false
    }
}

//MARK: Hole based stats
extension Hole {
    /// True if this hole was hit a green in regulation, false otherwise.
    ///
    /// A green in regulation is defined as being on the green for a birdie putt or better
    var greenInReg: Bool {
        
        if self.shots.count <= getPuttShot() {
            return true
        }
        
        // we can start at 1 becuase the first shot is always a drive
        for index in 1...self.getPuttShot() {
            if self.shots[index].type == .putt {
                return true
            }
        }
        
        
        return false
    }
    
    
    /// True if the fairway was hit, false if not, nil if the hole is a par 3 or there are no entries
    ///
    /// A fairway is defined as a drive where there is no penatly and the next shot is taken from the fairway or green.
    var fairway: Bool? {
        if self.holeData.par == 3 { return nil }
        // this means a hole out was present and it is a hit fairway
        if shots.isEmpty {
            return nil
        }
        
        if !shots[0].includesPenalty && (shots[0].endPosition.lie == .fairway || shots[0].endPosition.lie == .green) {
            return true
        }
        
        return false
    }
    
    
    /// Gets the shot index which a putt must be hit for a green in regulation
    /// - Returns: Gets the shot index where a putt must be hit for a green in regulation.
    private func getPuttShot() -> Int {
        let par = self.holeData.par
        precondition(par >= 3 && par <= 5)
        if par == 3 { return 1 }
        
        if par == 4 { return 2 }
        
        return 3
    }
    
    
    /// The number of putts hit on this hole
    var putts: Int {
        return self.shots.filter { $0.type == .putt }.count
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


