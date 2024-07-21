//
//  RoundBasedStats.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-05-14.
//

import SwiftUI

struct GreensFairwaysPutts: View {
  let round: Round
  var body: some View {
    HStack {
      GroupBox {
        VStack {
          let greenPercentage = Double(round.getGreens().0) / Double(round.getGreens().1)
          Text("\(round.getGreens().0) | " + greenPercentage.roundToPercent())

          Text("Greens")
            .font(.headline)
        }

      }

      GroupBox {
        VStack {
          Text("\(round.putts())")

          Text("Putts")
            .font(.headline)
        }
      }
      GroupBox {
        let fairwayPercentage = Double(round.fairways().0) / Double(round.fairways().1)
        Text("\(round.fairways().0) | " + fairwayPercentage.roundToPercent())
        Text("Fairways")
          .font(.headline)

      }

    }
  }
}

struct ScoreTypes: View {
  let round: Round
  var body: some View {

    Grid {
      GridRow {
        Group {
          Text("Eagles+")
          Text("Birdies")
          Text("Pars")
          Text("Bogeys")
          Text("Doubles+")
        }
        .font(.headline)
      }

      Divider()

      GridRow {
        Text(round.eaglesOrBetter, format: .number)
        Text(round.birdies, format: .number)
        Text(round.pars, format: .number)
        Text(round.bogeys, format: .number)
        Text(round.doubleBogeysOrWorse, format: .number)
      }
    }

  }
}

struct RoundBasedStats_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      ScoreTypes(round: Round.completeRoundExample1)
      GreensFairwaysPutts(round: Round.completeRoundExample1)

    }
  }
}
