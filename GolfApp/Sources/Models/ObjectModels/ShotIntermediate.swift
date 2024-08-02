import Foundation


struct ShotIntermediate: Identifiable, Equatable {
  
  let id: UUID = UUID()
  var position: Position
  var declaration: ShotDeclaration
  
  var type: ShotType {
    switch declaration {
    case .drive:
      return .drive
      
    case .atHole:
      switch position.lie {
      case .fairway, .bunker, .rough, .other, .tee:
        if position.yardage.yards > 50 {
          return .approach
        }
        return .chip_pitch
        
      case .green:
        return .putt
        
      case .penalty:
        fatalError("Penalty cannot be to hole")
      }
    case .drop:
      return .penalty
    case .other:
      return .other
      
    }
  }
  
  enum ShotDeclaration: String, CaseIterable, Identifiable {
    
    case drive = "Drive"
    case atHole = "At Hole"
    case other = "Other"
    case drop = "Drop"
    
    var id: Self { self }
  }
  
  static func getFirstShotPrediction(hole: Hole) -> ShotIntermediate {
    return .init(
      position: .init(lie: .tee, yardage: hole.holeData.yardage),
      declaration: hole.holeData.par == 3 ? .atHole : .drive)
  }
  
  func getNextValue(shotPredictor: ShotPredictor) -> ShotIntermediate {
    let suggestedPosition = shotPredictor.predictedNextLocation(self)
    
    return .init(
      position: suggestedPosition, declaration: suggestedPosition.expectedShotType())
  }
  
  
}

extension Array where Element == ShotIntermediate {
  func prepareShots() -> [Shot] {
    var index = 0
    var shotList = [Shot]()
    
    //below we enter the loop that fills the shots with their entries from the shot Intermidates.
    while index < self.count {
      
      if index != 0 {
        let pos1 = self[index - 1]
        
        var pos2 = self[index]
        if pos2.declaration == .drop {
          index += 1
          pos2 = self[index]
          shotList.append(
            Shot(
              type: pos1.type, startPosition: pos1.position, endPosition: pos2.position,
              includesPenalty: true))
        } else {
          shotList.append(
            Shot(
              type: pos1.type, startPosition: pos1.position, endPosition: pos2.position))
        }
      }
      index += 1
    }
    // adds the last shot that holes out the shot
    if let intermediate = self.last {
      shotList.append(
        .init(
          type: intermediate.type, startPosition: intermediate.position,
          endPosition: .holed))
    }
    
    return shotList
  }
  
  func is_valid() -> String? {
    if let first = self.first {
      if first.position.lie != .tee {
        return "First shot must be from tee"
      }
      
      let valid_tee_shots: [ShotIntermediate.ShotDeclaration] = [
        .drive,
        .atHole,
      ]
      
      if !valid_tee_shots.contains(first.declaration) {
        return "First shot cannot be a drop"
      }
    }
    
    if self.last?.declaration == .drop {
      return "Last shot cannot be a drop"
    }
    
    if self.isEmpty {
      return "No shots have been posted"
    }
    
    return nil
  }
  
  
}
