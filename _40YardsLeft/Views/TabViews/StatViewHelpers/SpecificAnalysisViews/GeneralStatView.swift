//
//  GeneralStatView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-08-21.
//

import SwiftUI

struct GeneralStatView: View {
    
    let rounds: [Round]
    var holeData: [DisplayStat<Double, Int>] {
        [
            DisplayStat(name: "Eagles+", value: Double(rounds.eaglesOrBetter()) / Double(rounds.count), numOfSamples: rounds.count, formatter: "%.1f"),
            DisplayStat(name: "Birdies", value: Double(rounds.birdies()) / Double(rounds.count), numOfSamples: rounds.count, formatter: "%.1f"),
            DisplayStat(name: "Pars", value: Double(rounds.pars()) / Double(rounds.count), numOfSamples: rounds.count, formatter: "%.1f"),
            DisplayStat(name: "Bogeys", value: Double(rounds.bogeys()) / Double(rounds.count), numOfSamples: rounds.count, formatter: "%.1f"),
            DisplayStat(name: "Double Bogeys+", value: Double(rounds.doubleBogeysOrWorse()) / Double(rounds.count), numOfSamples: rounds.count, formatter: "%.1f"),
            DisplayStat(name: "Par 3 Scoring", value: rounds.parScoringAverage(par: 3).0 ?? 0, numOfSamples: rounds.parScoringAverage(par: 3).1, formatter: "%.2f"),
            DisplayStat(name: "Par 4 Scoring", value: rounds.parScoringAverage(par: 4).0 ?? 0, numOfSamples: rounds.parScoringAverage(par: 4).1, formatter: "%.2f"),
            DisplayStat(name: "Par 5 Scoring", value: rounds.parScoringAverage(par: 5).0 ?? 0, numOfSamples: rounds.parScoringAverage(par: 5).1, formatter: "%.2f"),

        ]
    }
    
    var fullRoundScoring: [DisplayStat<Double, Int>] {
        [
            DisplayStat(name: "Scoring Average", value: rounds.scoringAverage() ?? 0, numOfSamples: rounds.count, formatter: "%.0f"),
            
            DisplayStat(name: "Front Nine Average", value: rounds.frontNineScoringAverage() ?? 0, numOfSamples: rounds.count, formatter: "%.0f"),
            
            DisplayStat(name: "Back Nine Average", value: rounds.backNineScoringAverage() ?? 0, numOfSamples: rounds.count, formatter: "%.0f"),
            
            DisplayStat(name: "Putts", value: rounds.puttsAverage() ?? 0, numOfSamples: rounds.count, formatter: "%.0f"),
            
            DisplayStat(name: "Bounce Back", value: Double(rounds.bounceBack().0) / Double(rounds.bounceBack().1) * 100, numOfSamples: rounds.bounceBack().1, formatter: "%.0f", isPercent: true),
            
            DisplayStat(name: "Birdie Streak", value: Double(rounds.birdieStreak()), formatter: "%.0f"),
            
            DisplayStat(name: "Bogey Streak", value: Double(rounds.bogeyStreak()), formatter: "%.0f"),
            
        ]
    }
    
    
    var body: some View {
        VStack {
            List {
                Section {
                    StatTable(titleValuePairs: self.holeData)
                } header: {
                    Text("Hole-By-Hole")
                        .font(.headline)
                        
                }
                
                Section {
                    StatTable(titleValuePairs: self.fullRoundScoring)
                } header: {
                    Text("Full Round")
                        .font(.headline)
                        
                }
            }
            
        }
    }
}

struct GeneralStatView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralStatView(rounds: [Round.completeRoundExample1])
    }
}
