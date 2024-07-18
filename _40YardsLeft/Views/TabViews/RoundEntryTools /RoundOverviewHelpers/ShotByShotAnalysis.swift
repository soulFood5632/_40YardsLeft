//
//  ShotByShotAnalysis.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-08-31.
//

import SwiftUI

struct ShotByShotAnalysis: View {
  let shot: (Shot, Int)
  var body: some View {
    HStack {
      Text("\(shot.1).")
        .bold()
      Text(shot.0.toString())
        .font(.caption)

      Spacer()
      if let strokes = shot.0.strokesGained {
        Text("\(strokes, specifier: "%.2f")")
      } else {
        Text("N/A")
      }
    }

  }
}

struct ShotByShotAnalysis_Previews: PreviewProvider {
  static var previews: some View {
    Grid {
      GridRow {
        ShotByShotAnalysis(
          shot: (
            Shot.init(
              type: .approach, startPosition: .init(lie: .fairway, yardage: .yards(110)),
              endPosition: .init(lie: .green, yardage: .feet(21))), 1
          ))
      }
    }
  }
}
