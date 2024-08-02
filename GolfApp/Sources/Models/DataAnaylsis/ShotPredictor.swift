//
//  PredictedShot.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-28.
//

import Foundation

struct UserDistanceValues: Codable, Hashable {

  /// The mininum distance that the user will lay up to
  ///
  /// - Note: This is a predicative measure which is not critical to app functionality
  var minimumApproachDistance: Distance = .yards(80)
  /// The maximum distance the user will attempt to approach the green on.
  ///
  /// - Note: This is a predicative measure which is not critical to app functionality
  var maximumApproachDistance: Distance = .yards(240)
  /// The usual drive distance of this user.
  ///
  /// - Note: This is a predicative measure which is not critical to app functionality
  var driveDistance: Distance = .yards(240)
  /// The average proximity of a shot when attempting the green in feet.
  var averageProximity: Distance = .feet(26)

  var chipProximity: Distance = .feet(10)

  /// The average distance your recovery distance travels
  var averageRecoveryDistance: Distance = .yards(75)

}

//MARK: Shot Predictor Class
class ShotPredictor {

  private var userDistanceValues: UserDistanceValues

  private static let DROP_PENALTY = Distance.yards(10)
  private static let CHIP_CUTOFF = Distance.yards(10)
  private static let FAIRWAY_PROX_BOOST = 0.7
  private static let LAYUP_DISTANCE_FACTOR = 0.84
  private static let BUNKER_DISTANCE_PENALTY = 0.8
  private static let BUNKER_PROX_BOOST = 1.6
  private static let SECOND_PUTT_DISTANCE = Distance.feet(2)

  init(golfer: Golfer) {
    self.userDistanceValues = golfer.getShotPredictor()

  }

  init() {
    self.userDistanceValues = UserDistanceValues()
  }

}

//MARK: Predictor Methods
extension ShotPredictor {
  //TODO: finish this spec

  /// Gets the next predicted location from the provided position.
  ///
  /// The logic is as follows:
  ///
  ///
  /// - Parameters:
  ///  - position: The position where the last shot has taken place from.
  ///  - par: The par of the hole which must be valid (between 3 and 5)
  ///
  /// - Returns: The predicted location of the next shot based on par
  func predictedNextLocation(_ shotI: ShotIntermediate) -> Position {
    if shotI.declaration == .drop {
      return shotI.position
    }
    if shotI.declaration == .drive {
      return expectShotFromTee(distance: shotI.position.yardage)
    }
    // hand
    switch shotI.position.lie {
      case .tee:
        return expectShotFromTeePar3(distance: shotI.position.yardage)
      case .fairway:
        return expectShotFromFairway(distance: shotI.position.yardage)
      case .rough:
        return expectShotFromRough(distance: shotI.position.yardage)
      case .penalty:
        return expectShotFromPenalty(distance: shotI.position.yardage)
      case .bunker:
        return expectShotFromBunker(distance: shotI.position.yardage)
      case .other:
        return expectShotFromRecovery(distance: shotI.position.yardage)
      case .green:
        return expectShotFromGreen(distance: shotI.position.yardage)
    }
  }

  private func expectShotFromTeePar3(distance: Distance) -> Position {
    return Position(lie: .green, yardage: userDistanceValues.averageProximity)
  }

  /// Gets the expected shot from a tee lie for the given Distance.
  ///
  /// - Parameter distance: The distance from which you would like to predict the nest shot to go to.
  /// - Returns: A position where the most likely point for the shot to be located.
  private func expectShotFromTee(distance: Distance) -> Position {

    if distance < userDistanceValues.maximumApproachDistance {
      return Position(lie: .green, yardage: userDistanceValues.averageProximity)
    }

    let expectedYardage = distance - self.userDistanceValues.driveDistance

    if expectedYardage > self.userDistanceValues.minimumApproachDistance {
      return Position(lie: .fairway, yardage: expectedYardage)
    }

    return Position(
      lie: .fairway, yardage: self.userDistanceValues.minimumApproachDistance)
  }

  ///Gets the predicted location of the next shot from the fairway.
  private func expectShotFromFairway(distance: Distance) -> Position {
    // handles chip shots.
    if distance < userDistanceValues.minimumApproachDistance {
      return Position.init(
        lie: .green,
        yardage: userDistanceValues.chipProximity.scaleBy(Self.FAIRWAY_PROX_BOOST))
    }

    if distance < userDistanceValues.maximumApproachDistance {
      return Position(
        lie: .green,
        yardage: userDistanceValues.averageProximity.scaleBy(Self.FAIRWAY_PROX_BOOST))
    }

    let expectedYardage =
      distance - self.userDistanceValues.driveDistance.scaleBy(Self.LAYUP_DISTANCE_FACTOR)

    if expectedYardage > userDistanceValues.minimumApproachDistance {
      return Position(lie: .fairway, yardage: expectedYardage)
    }

    return Position(lie: .fairway, yardage: userDistanceValues.minimumApproachDistance)
  }

  private func expectShotFromRough(distance: Distance) -> Position {
    if distance < userDistanceValues.minimumApproachDistance {
      return Position.init(lie: .green, yardage: userDistanceValues.chipProximity)
    }
    if distance < userDistanceValues.maximumApproachDistance {
      return Position(lie: .green, yardage: userDistanceValues.averageProximity)
    }

    let expectedYardage =
      distance - self.userDistanceValues.driveDistance.scaleBy(Self.LAYUP_DISTANCE_FACTOR)

    if expectedYardage > userDistanceValues.minimumApproachDistance {
      return Position(lie: .fairway, yardage: expectedYardage)
    }

    return Position(lie: .fairway, yardage: userDistanceValues.minimumApproachDistance)
  }

  private func expectShotFromBunker(distance: Distance) -> Position {
    if distance < userDistanceValues.minimumApproachDistance {
      return Position.init(
        lie: .green,
        yardage: userDistanceValues.chipProximity.scaleBy(Self.BUNKER_PROX_BOOST))
    }
    if distance
      < userDistanceValues.maximumApproachDistance.scaleBy(Self.BUNKER_DISTANCE_PENALTY)
    {
      return Position(
        lie: .green,
        yardage: userDistanceValues.averageProximity.scaleBy(Self.BUNKER_PROX_BOOST))
    }

    let expectedYardage =
      distance - self.userDistanceValues.driveDistance.scaleBy(Self.LAYUP_DISTANCE_FACTOR)

    if expectedYardage > userDistanceValues.minimumApproachDistance {
      return Position(lie: .fairway, yardage: expectedYardage)
    }

    return Position(lie: .fairway, yardage: userDistanceValues.minimumApproachDistance)
  }

  private func expectShotFromPenalty(distance: Distance) -> Position {
    return Position(lie: .rough, yardage: distance + Self.DROP_PENALTY)
  }

  private func expectShotFromRecovery(distance: Distance) -> Position {
    let expectedYardage = distance - self.userDistanceValues.averageRecoveryDistance
    if expectedYardage > .yards(30) {
      return Position(lie: .fairway, yardage: expectedYardage)
    }

    return Position(lie: .rough, yardage: expectedYardage)
  }

  private func expectShotFromGreen(distance: Distance) -> Position {

    return Position(lie: .green, yardage: Self.SECOND_PUTT_DISTANCE)

  }
}

//MARK: Shot Type Predictor
extension ShotPredictor {

  func getPredictedShot(position: Position, par: Int) -> ShotType {
    switch position.lie {
      case .tee:
        if par == 3 || position.yardage < self.userDistanceValues.maximumApproachDistance
        {
          return .approach
        }
        return .drive
      case .green:
        return .putt
      case .rough, .fairway, .bunker:
        if position.yardage > Self.CHIP_CUTOFF {
          return .approach
        }
        return .chip_pitch
      case .other:
        return .other
      case .penalty:
        return .other
    }
  }

}
