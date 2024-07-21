//
//  PuttingDetailView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-08-21.
//

import SwiftUI

struct PuttingDetailView: View {
  let shots: [Shot]

  var puttingRanges: [Range<Distance>] {
    Distance.getSplitRegoins(at: [3, 5, 7, 10, 15, 20, 30, 60])
  }

  var strokesGained: (Double, Int) {
    return (
      shots.strokesGained(ShotFilters.allPutts), shots.filter { $0.type == .putt }.count
    )
  }

  var body: some View {
    VStack {

      Text("Putting Detail View")
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
        Grid {
          GridRow(alignment: .top) {
            Text("Distance (ft.)")
              .font(.title3)
              .bold()
              .multilineTextAlignment(.center)

            Text("Make Percentage")
              .font(.title3)
              .bold()
              .multilineTextAlignment(.center)

            Text("Strokes Gained")
              .font(.title3)
              .bold()
              .multilineTextAlignment(.center)

          }

          Divider()

          ForEach(self.puttingRanges, id: \.lowerBound) { range in
            GridRow {

              if range.upperBound == Distance.MAX_DISTANCE {
                Text("\(range.lowerBound.feet, specifier: "%.0f")+")
              } else {
                Text(
                  "\(range.lowerBound.feet, specifier: "%.0f") - \(range.upperBound.feet, specifier: "%.0f")"
                )
              }

              VStack {
                Text(
                  "\((shots.makePercentageFrom(range: range) ?? 0) * 100, specifier: "%.0f") %"
                )
                Text(
                  "\(shots.filter(ShotFilters.allPutts).filter { range.contains($0.startPosition.yardage) }.count)"
                )
                .font(.caption)
              }

              VStack {

                let strokesGained = shots.strokesGained { shot in
                  return shot.type == .putt && range.contains(shot.startPosition.yardage)
                }
                let numberOfShots = shots.filter(ShotFilters.allPutts).filter {
                  range.contains($0.startPosition.yardage)
                }.count
                Text("\(strokesGained, specifier: "%.2f") ")

                if numberOfShots == 0 {
                  Text("0 per shot")
                    .font(.caption)
                } else {
                  Text(
                    "\(strokesGained / Double(numberOfShots), specifier: "%.2f") per shot"
                  )
                  .font(.caption)
                }
              }
            }
          }
        }
      }
    }
  }
}

extension PuttingDetailView {


}

struct PuttingDetailView_Previews: PreviewProvider {
  static var previews: some View {
    PuttingDetailView(shots: Shot.exampleShotList)
  }
}
