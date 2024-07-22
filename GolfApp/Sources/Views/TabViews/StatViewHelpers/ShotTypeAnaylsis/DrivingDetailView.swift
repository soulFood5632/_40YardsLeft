//
//  DrivingDetailView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-08-21.
//

import SwiftUI

struct DrivingDetailView: View {
  let shots: [Shot]

  var strokesGained: (Double, Int) {
    return (
      shots.strokesGained(ShotFilters.allTeeShots),
      shots.filter { $0.type == .drive }.count
    )
  }

  var lostBallPercentage: (Double?, Int) {
    return (
      shots.percentageLostBall(shotType: .drive), shots.filter { $0.type == .drive }.count
    )
  }

  var treePercentage: (Double?, Int) {
    return (
      shots.percentageEndingIn(lies: [.other], shotType: .drive),
      shots.filter { $0.type == .drive }.count
    )
  }

  var drivingDistance: (Distance?, Int) {
    return (
      shots.map { $0.advancementYardage }.average(),
      shots.filter { $0.type == .drive }.count
    )
  }

  var body: some View {
    VStack {

      Text("Driving Detail View")
        .font(.title)
        .bold()
      Text("\(self.strokesGained.1) shots")

      Divider()
        .padding(.horizontal)
        .padding(.vertical, 4)

      HStack {
        Text("Strokes Gained:")
          .font(.title3)
          .bold()

        VStack {
          Text("\(self.strokesGained.0, specifier: "%.1f")")
            .bold()

          let strokesGainedPerShot = self.strokesGained.0 / Double(self.strokesGained.1)

          if self.strokesGained.1 == 0 {
            Text("0 per shot")
              .font(.caption)
          } else {
            Text("\(strokesGainedPerShot, specifier: "%.2f") per shot")
              .font(.caption)
          }
        }

      }

      Divider()
        .padding(.horizontal)
        .padding(.vertical, 4)

      GroupBox {
        Grid(horizontalSpacing: 10) {
          GridRow {
            Text("Driving Distance")
              .font(.title3)
              .bold()

            Text("Trouble %")
              .font(.title3)
              .bold()
          }
          Divider()

          GridRow {
            VStack {
              Text("\(self.drivingDistance.0?.yards ?? 0, specifier: "%.0f")")
                .bold()

              Text("\(self.lostBallPercentage.1)")
                .font(.caption)
            }

            let combinedPercentages =
              (self.treePercentage.0 ?? 0) + (self.lostBallPercentage.0 ?? 0)
            VStack {
              Text("\(combinedPercentages * 100, specifier: "%.0f")")
                .bold()
              Text("\(self.lostBallPercentage.1)")
                .font(.caption)
            }
          }
        }

      }
    }
  }
}

struct DrivingDetailView_Previews: PreviewProvider {
  static var previews: some View {
    DrivingDetailView(shots: Shot.exampleShotList)
  }
}
