//
//  PuttingStatView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-08-21.
//

import Charts
import SwiftUI

struct PuttingStatView: View {
  let rounds: [Round]

  @State private var distanceBounds: Range<Distance> =
    Distance(feet: 10)..<Distance(feet: 50)

  var shotFilter: (Shot) -> Bool {
    return { shot in
      return distanceBounds.contains(shot.startPosition.yardage) && shot.type == .putt

    }
  }

  var puttingRanges: [Range<Distance>] {
    PuttingDetailView.getSplitRegoins(at: [3, 5, 7, 10, 15, 20, 30, 60])
  }

  var strokesGained: [DisplayStat<Double, Int>] {
    let perShot =
      rounds.strokesGained(for: .putt).0 / Double(rounds.strokesGained(for: .putt).1)

    let perRound =
      rounds.strokesGained(for: .putt).0 / Double(rounds.strokesGained(for: .putt).2)

    return [
      DisplayStat(
        name: "Strokes Gained Per Shot", value: perShot.isNaN ? 0 : perShot,
        numOfSamples: rounds.strokesGained(for: .chip_pitch).1, formatter: "%.2f"),
      DisplayStat(
        name: "Strokes Gained Per Round", value: perRound.isNaN ? 0 : perRound,
        numOfSamples: rounds.count, formatter: "%.2f"),
    ]
  }

  var shots: [Shot] {
    do {
      return try self.rounds
        .map { $0.holes }
        .flatten()
        .map { try $0.getSimplifiedShots() }
        .flatten()
    } catch {
      preconditionFailure("Line should never be reached")

    }
  }

  var makeStats: [DisplayStat<Double, Int>] {

    var statList = [DisplayStat<Double, Int>]()
    for range in self.puttingRanges {

      var headerString: String

      if range.upperBound == Distance.MAX_DISTANCE {
        headerString = String(format: "%.0f", range.lowerBound.feet) + "+"
      } else {
        headerString =
          String(format: "%.0f", range.lowerBound.feet) + " - "
          + String(format: "%.0f", range.upperBound.feet)
      }

      statList.append(
        DisplayStat(
          name: headerString,
          value: (shots.makePercentageFrom(range: range) ?? 0) * 100,
          numOfSamples: shots.filter(ShotFilters.allPutts).filter {
            range.contains($0.startPosition.yardage)
          }.count,
          formatter: "%.1f",
          isPercent: true))
    }

    return statList
  }

  var strokesGainedStats: [DisplayStat<Double, Int>] {
    var statList = [DisplayStat<Double, Int>]()

    for range in self.puttingRanges {

      var headerString: String

      if range.upperBound == Distance.MAX_DISTANCE {
        headerString = String(format: "%.0f", range.lowerBound.feet) + "+"
      } else {
        headerString =
          String(format: "%.0f", range.lowerBound.feet) + " - "
          + String(format: "%.0f", range.upperBound.feet)
      }

      let filter: (Shot) -> Bool = { shot in
        return shot.type == .putt && range.contains(shot.startPosition.yardage)
      }
      let strokesGained = shots.strokesGained(filter)
      let totalShots = shots.filter(filter).count

      let perShot = Double(strokesGained) / Double(totalShots)

      statList.append(
        DisplayStat(
          name: headerString,
          value: perShot.isNaN ? 0 : perShot,
          numOfSamples: totalShots,
          formatter: "%.2f"))
    }

    return statList
  }

  var avgStrokesToHoleOut: [DisplayStat<Double, Int>] {
    var statList = [DisplayStat<Double, Int>]()

    for range in self.puttingRanges {

      var headerString: String

      if range.upperBound == Distance.MAX_DISTANCE {
        headerString = String(format: "%.0f", range.lowerBound.feet) + "+"
      } else {
        headerString =
          String(format: "%.0f", range.lowerBound.feet) + " - "
          + String(format: "%.0f", range.upperBound.feet)
      }

      let filter: (Shot) -> Bool = { shot in
        return shot.type == .putt && range.contains(shot.startPosition.yardage)
      }
      let avgStrokes = rounds.strokesToHoleOut(filter).0
      let totalShots = rounds.strokesToHoleOut(filter).1

      let perShot = (avgStrokes ?? 0)

      statList.append(
        DisplayStat(
          name: headerString,
          value: perShot.isNaN ? 0 : perShot,
          numOfSamples: totalShots,
          formatter: "%.2f"))
    }

    return statList
  }

  var threePuttOdds: [DisplayStat<Double, Int>] {
    var statList = [DisplayStat<Double, Int>]()

    for range in self.puttingRanges {

      var headerString: String

      if range.upperBound == Distance.MAX_DISTANCE {
        headerString = String(format: "%.0f", range.lowerBound.feet) + "+"
      } else {
        headerString =
          String(format: "%.0f", range.lowerBound.feet) + " - "
          + String(format: "%.0f", range.upperBound.feet)
      }

      let filter: (Shot) -> Bool = { shot in
        return shot.type == .putt && range.contains(shot.startPosition.yardage)
      }
      let threePutts = rounds.threePuttOccurance(filter).0
      let totalOpps = rounds.threePuttOccurance(filter).1

      let perShot = Double(threePutts) / Double(totalOpps) * 100

      statList.append(
        DisplayStat(
          name: headerString,
          value: perShot.isNaN ? 0 : perShot,
          numOfSamples: totalOpps,
          formatter: "%.1f", isPercent: true))
    }

    return statList
  }

  var body: some View {
    GroupBox {
      VStack {
        List {

          Chart(rounds) {
            PointMark(
              x: .value("Date", $0.date),
              y: .value("Strokes Gained", $0.strokesGainedPutting())
            )
            .foregroundStyle(by: .value("Round Type", $0.roundType.rawValue))

            RuleMark(y: .value("Tour Average", 0))
              .foregroundStyle(.secondary)
          }
          .padding()

          Section {
            StatTable(titleValuePairs: self.strokesGained)
          } header: {
            Text("Overall")
              .font(.headline)
          }

          Section {
            StatTable(titleValuePairs: self.makeStats)
          } header: {
            Text("Make Percentages")
              .font(.headline)
          }

          Section {
            StatTable(titleValuePairs: self.avgStrokesToHoleOut)
          } header: {
            Text("Strokes to Hole out")
              .font(.headline)
          }

          Section {
            StatTable(titleValuePairs: self.threePuttOdds)
          } header: {
            Text("3 Putts Avoidance")
              .font(.headline)
          }

          Section {
            StatTable(titleValuePairs: self.strokesGainedStats)
          } header: {
            Text("Strokes Gained")
              .font(.headline)
          }

        }
      }
      .animation(.easeInOut, value: self.distanceBounds)
    } label: {
      Text("Putting")
        .font(.title)
        .bold()
    }
    .padding()

  }
}

struct PuttingStatView_Previews: PreviewProvider {
  static var previews: some View {
    PuttingStatView(rounds: [Round.completeRoundExample1])
  }
}
