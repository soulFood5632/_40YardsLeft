//
//  TendancyAnalyser.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-06.
//

import Foundation
import SigmaSwiftStatistics

struct TendancyAnalyzer {

  let shots: [Shot]

  func getDriveDistance() async -> Distance {
    /// Gets a tuple where the first value is
    let numberAndValues =
      shots
      .filter { $0.type == .drive }
      .reduce((0.0, Distance.zero)) { partialResult, shot in
        var copy = partialResult
        copy.0 += 1
        copy.1 += shot.advancementYardage
        return copy
      }

    return numberAndValues.1.scaleBy(1 / Double(numberAndValues.0))
  }

  /// Gets the approach which is
  /// - Returns: <#description#>
  func getMinimumApproachAndMaxApproach() async -> (Distance, Distance) {
    let approachValues =
      shots
      .filter({ $0.type == .approach })
      .map { $0.startPosition }
    // sorts the given values from largest to smallest

    return (.zero, .zero)

  }

}
