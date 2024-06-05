//
//  Shot.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-25.
//

import Foundation

//MARK: Shot Init
struct Shot : Codable, Hashable, Identifiable {
    /// The type of shot.
    let type: ShotType
    /// where the shot originated from
    let startPosition: Position
    /// where the shot ended up
    let endPosition: Position
    ///Does this shot include a penatly stroke?
    let includesPenalty: Bool
    
    let id: UUID
    
    /// The strokes gained of this shot if it is calculatable.
    ///
    /// If one of either the start or end position is of the lie penatly, then there will be no way to tell this value so it is nil.
    let strokesGained: Double?
    
    init(type: ShotType, startPosition: Position, endPosition: Position, includesPenalty: Bool) {
        self.type = type
        self.startPosition = startPosition
        self.endPosition = endPosition
        self.includesPenalty = includesPenalty
        self.id = UUID()
        do {
            self.strokesGained = try Self.getStrokesGained(start: startPosition, end: endPosition, includesPenalty: includesPenalty)
        } catch {
            self.strokesGained = nil
        }
    }
    
    
    /// Creates a new instance of a shot that does not include a penalty.
    ///
    /// - Parameters:
    ///   - type: The shot type that this shot was taken
    ///   - startPosition: The position in which this shot started at.
    ///   - endPosition: The position in which this shot ended up at.
    init(type: ShotType, startPosition: Position, endPosition: Position) {
        self.type = type
        self.startPosition = startPosition
        self.endPosition = endPosition
        self.includesPenalty = false
        self.id = UUID()
        do {
            self.strokesGained = try Self.getStrokesGained(start: startPosition, end: endPosition, includesPenalty: false)
        } catch {
            self.strokesGained = nil
        }
    }
    
    
    /// Gets the strokes gained from the start
    ///
    /// - Parameters:
    ///   - start: The start position of this shot.
    ///   - end: The end position of this shot
    ///   - includesPenalty: Whether or not this shot includes a penalty stroke
    /// - Returns: A double containing the strokes gained value of the shot
    private static func getStrokesGained(start: Position, end: Position, includesPenalty: Bool) throws -> Double {
        if includesPenalty {
            return try start.getExpectedStrokes() - end.getExpectedStrokes() - 2
        }
        return try start.getExpectedStrokes() - end.getExpectedStrokes() - 1
    }
    
}

// MARK: Example shot list of various sizes
extension Shot {

    
    static let exampleShotList: [Shot] = {
        var shotList = [Shot]()
        
        for index in 0..<1000 {
            let randomValue = Int.random(in: 0..<100)
            
            if randomValue < 20 {
                shotList.append(Shot(type: .drive, startPosition: .init(lie: .tee, yardage: .init(yards: Int.random(in: 350..<450))), endPosition: .init(lie: [.fairway, .rough].randomElement()!, yardage: .init(yards: Int.random(in: 100..<175)))))
            } else if randomValue < 50 {
                shotList.append(Shot(type: .approach, startPosition: .init(lie: [.fairway, .rough].randomElement()!, yardage: .init(yards: Int.random(in: 50..<250))), endPosition: .init(lie: [.green, .rough, .bunker].randomElement()!, yardage: .init(feet: Int.random(in: 1..<120)))))
            } else if randomValue < 70 {
                shotList.append(Shot(type: .chip_pitch, startPosition: .init(lie: [.fairway, .rough, .bunker].randomElement()!, yardage: .init(yards: Int.random(in: 10..<50))), endPosition: .init(lie: .green, yardage: .init(feet: Int.random(in: 1..<50)))))
            } else if randomValue < 75 {
                shotList.append(Shot(type: .other, startPosition: .init(lie: [.fairway, .rough].randomElement()!, yardage: .init(yards: Int.random(in: 50..<400))), endPosition: .init(lie: [.fairway, .rough].randomElement()!, yardage: .init(yards: Int.random(in: 25..<200)))))
            } else {
                shotList.append(Shot(type: .putt, startPosition: .init(lie: .green, yardage: .init(feet: Int.random(in: 1..<90))), endPosition: [.holed, .init(lie: .green, yardage: .init(feet: Int.random(in: 1..<9)))].randomElement()!))
            }

        }
        
        return shotList
    }()
}


//MARK: Shot computed values.
extension Shot {
    
    /// The releative yardage that this shot was sent.
    var advancementYardage: Distance { startPosition.yardage - endPosition.yardage }
    /// The number of shots that this shot has counted for.
    var numOfShots: Int {
        if includesPenalty {
            return 2
        }
        return 1
    }
    
    /// A variable which is true if the last shot of this hole ends in a holed shot.
    var isHoled: Bool { return endPosition == .holed }
    
    func toString() -> String {
        if self.includesPenalty {
            return self.startPosition.toString() + " -> PENALTY -> " + self.endPosition.toString() 
        }
        return self.startPosition.toString() + " -> " + self.endPosition.toString()
    }
    
}

//MARK: ShotType Enum
enum ShotType : String, Codable, CaseIterable, Hashable {
    case drive = "Drive"
    case approach = "Approach"
    case chip_pitch = "Chip/Pitch"
    case putt = "Putt"
    case penalty = "Penalty"
    case other = "Other"
}

enum AnalysisFocus: String, CaseIterable, Hashable, Identifiable {
    var id: Self { self }

    case approach = "Approach"
    case chipping = "Chipping"
    case putting = "Putting"
    case tee = "Tee"
    // TODO: add the strokes gained functionality. 
    
    
}


