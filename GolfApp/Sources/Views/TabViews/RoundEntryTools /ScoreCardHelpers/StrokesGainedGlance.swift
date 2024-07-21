//
//  StrokesGainedGlance.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2024-06-19.
//

import SwiftUI

struct StrokesGainedGlance: View {
  let round: Round
  var strokesGained: StrokesGainedData {
    StrokesGainedData(
      shots: round
        .holes
        .filter { $0.isComplete }
        .map { try! $0.getSimplifiedShots() }
        .flatten()
    )
  }

  var body: some View {
    Grid(horizontalSpacing: 25) {

      GridRow {
        Text(strokesGained.approachString)
          .foregroundStyle(strokesGained.approach >= 0 ? .green : .red)
        Text(strokesGained.chippingString)
          .foregroundStyle(strokesGained.chipping >= 0 ? .green : .red)
        Text(strokesGained.puttingString)
          .foregroundStyle(strokesGained.putting >= 0 ? .green : .red)
        Text(strokesGained.teeString)
          .foregroundStyle(strokesGained.tee >= 0 ? .green : .red)
      }

      GridRow {
        Group {
          Text("Approach")
          Text("Short Game")
          Text("Putting")
          Text("Driving")
        }
        .font(.caption)
      }

    }

  }

}

#Preview {

  StrokesGainedGlance(round: Round.completeRoundExample1)
}
