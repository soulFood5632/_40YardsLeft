//
//  DrivingStatView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-08-21.
//

import SwiftUI
import Charts

struct DrivingStatView: View {
    let rounds: [Round]
    
    var drivingStats: [DisplayStat<Double, Int>] {
        [
            DisplayStat(name: "Strokes Gained Per Shot", value: rounds.strokesGained(for: .drive ).0 / Double(rounds.strokesGained(for: .drive).1), numOfSamples: rounds.strokesGained(for: .drive).1, formatter: "%.2f"),
            DisplayStat(name: "Strokes Gained Per Round", value: rounds.strokesGained(for: .drive ).0 / Double(rounds.strokesGained(for: .drive).2), numOfSamples: rounds.count, formatter: "%.2f"),
            DisplayStat(name: "Driving Distance", value: rounds.averageDrivingDistance().0?.yards ?? 0, numOfSamples: rounds.averageDrivingDistance().1, formatter: "%.1f"),
            
            
            DisplayStat(name: "Fairway", value: Double(rounds.fairways().0) / Double(rounds.fairways().1) * 100, numOfSamples: rounds.fairways().1, formatter: "%.1f", isPercent: true),
            DisplayStat(name: "Open Shot", value: Double(rounds.openShotPercentage().0) / Double(rounds.openShotPercentage().1) * 100, numOfSamples: rounds.openShotPercentage().1, formatter: "%.1f", isPercent: true),
            DisplayStat(name: "Penalty", value: Double(rounds.penaltyPercentage().0 ?? 0) * 100 , numOfSamples: rounds.penaltyPercentage().1, formatter: "%.1f", isPercent: true),
            DisplayStat(name: "Trees", value: Double(rounds.treePercentage().0 ?? 0) * 100 , numOfSamples: rounds.treePercentage().1, formatter: "%.1f", isPercent: true),
            
        ]
    }
    var body: some View {
        VStack {
            Chart(rounds) {
                PointMark(
                    x: .value("Date", $0.date),
                    y: .value("Strokes Gained", $0.strokesGainedTee())
                )
                .foregroundStyle(by: .value("Round Type", $0.roundType.rawValue))
            }
            .padding()
            
            List {
                Section {
                    StatTable(titleValuePairs: self.drivingStats)
                } header: {
                    Text("Accuracy")
                }
            }
        }
    }
}

struct DrivingStatView_Previews: PreviewProvider {
    static var previews: some View {
        DrivingStatView(rounds: [Round.completeRoundExample1])
    }
}
