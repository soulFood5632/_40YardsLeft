//
//  ScorecardView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-31.
//

import SwiftUI

struct ScorecardView: View {
  let round: Round

  @Binding var currentHole: Int
  @Binding var showView: Bool

  var body: some View {
    VStack {
      GroupBox {
        ScorecardImage(round: self.round)
          .padding(.vertical, 3)
      } label: {
        Label("Scorecard", systemImage: "square.grid.3x2")
      }
      .padding(.horizontal)
      .padding(.top, 10)

      GroupBox {
        StrokesGainedGlance(round: round)
          .padding(5)
      } label: {
        Label("Stats", systemImage: "chart.bar")
      }
      .padding(.horizontal)

      GroupBox {
        HoleButtons(round: round, holeNumber: self.$currentHole)
      } label: {
        Label(
          "Navigation", systemImage: "point.topleft.down.curvedto.point.bottomright.up")
      }
      .padding(.horizontal)

    }
    .onChange(of: self.currentHole) { _ in
      self.showView = false
    }
  }
}

struct ScorecardView_Previews: View {
  @State private var currentHole = 10
  @State private var showView = true
  var body: some View {
    ScorecardView(
      round: .completeRoundExample1, currentHole: self.$currentHole,
      showView: self.$showView)
  }
}

#Preview {
  ScorecardView_Previews()
}
