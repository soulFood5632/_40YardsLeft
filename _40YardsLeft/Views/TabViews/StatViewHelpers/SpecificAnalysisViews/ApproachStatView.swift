//
//  ApproachStatView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-08-21.
//

import SwiftUI
import Charts

struct ApproachStatView: View {
    let rounds: [Round]
    
    @State private var distanceBounds: Range<Distance> = Distance(yards: 50)..<Distance(yards: 250)
    @State private var lies: [Lie] = [.fairway]
    
    var strokesGained: [DisplayStat<Double, Int>] {
        [
            DisplayStat(name: "Strokes Gained Per Shot", value: rounds.strokesGained(for: .approach).0 / Double(rounds.strokesGained(for: .approach).1), numOfSamples: rounds.strokesGained(for: .approach).1, formatter: "%.2f"),
            DisplayStat(name: "Strokes Gained Per Round", value: rounds.strokesGained(for: .approach ).0 / Double(rounds.strokesGained(for: .approach).2), numOfSamples: rounds.count, formatter: "%.2f"),
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
    
    var approachStats: [DisplayStat<Double, Int>] {
        [
            
            DisplayStat(name: "Greens", value: Double(rounds.greensInReg().0) / Double(rounds.greensInReg().1) * 100, numOfSamples: rounds.greensInReg().1, formatter: "%.1f", isPercent: true),
            DisplayStat(name: "Proximity", value: shots.proximityFrom(ShotFilters.allApproach)?.feet ?? 0, numOfSamples: shots.filter(ShotFilters.allApproach).count, formatter: "%.1f"),
            DisplayStat(name: "Success Rate", value: (shots.percentageEndingIn(lies: [.green], shotType: .approach) ?? 0) * 100, numOfSamples: shots.filter(ShotFilters.allApproach).count, formatter: "%.1f", isPercent: true),
            DisplayStat(name: "Strokes To Hole Out", value: rounds.strokesToHoleOut(ShotFilters.allApproach).0 ?? 0, numOfSamples: rounds.strokesToHoleOut(ShotFilters.allApproach).1, formatter: "%.2f"),
        ]
    }
    
    var specificApproachStats: [DisplayStat<Double, Int>] {
        
        let strokesGained = shots.strokesGained { self.distanceBounds.contains($0.startPosition.yardage) && self.lies.contains($0.startPosition.lie) && $0.type == .approach }
        let totalShots = shots.filter {self.distanceBounds.contains($0.startPosition.yardage) && self.lies.contains($0.startPosition.lie) && $0.type == .approach }.count
        
        let filter: (Shot) -> Bool = { self.distanceBounds.contains($0.startPosition.yardage) && self.lies.contains($0.startPosition.lie) && $0.type == .approach }
        
        if totalShots == 0 {
            return [
                DisplayStat(name: "Strokes Gained", value: 0, numOfSamples: totalShots, formatter: "%.2f"),
            DisplayStat(name: "Proximity", value: shots.approachProximityFrom(range: self.distanceBounds, lie: self.lies, shotType: .approach)?.feet ?? 0, numOfSamples: totalShots, formatter: "%.1f"),
            DisplayStat(name: "Success Rate", value: (shots.greenPercentageFrom(range: self.distanceBounds, lie: self.lies, shotType: .approach) ?? 0) * 100, numOfSamples: totalShots, formatter: "%.1f", isPercent: true),
                DisplayStat(name: "Strokes To Hole Out", value: rounds.strokesToHoleOut(filter).0 ?? 0, numOfSamples: rounds.strokesToHoleOut(filter).1, formatter: "%.2f"),
                ]
        }
        return [
            

            DisplayStat(name: "Strokes Gained", value: Double(strokesGained) / Double(totalShots), numOfSamples: totalShots, formatter: "%.2f"),
            DisplayStat(name: "Proximity", value: shots.approachProximityFrom(range: self.distanceBounds, lie: self.lies, shotType: .approach)?.feet ?? 0, numOfSamples: totalShots, formatter: "%.1f"),
            DisplayStat(name: "Success Rate", value: (shots.greenPercentageFrom(range: self.distanceBounds, lie: self.lies, shotType: .approach) ?? 0) * 100, numOfSamples: totalShots, formatter: "%.1f", isPercent: true),
            DisplayStat(name: "Strokes To Hole Out", value: rounds.strokesToHoleOut(filter).0 ?? 0, numOfSamples: rounds.strokesToHoleOut(filter).1, formatter: "%.2f"),
            
        ]
    }
    var body: some View {
        GroupBox {
            VStack {
                
                List {
                    
                    Chart(rounds) {
                        PointMark(
                            x: .value("Date", $0.date),
                            y: .value("Strokes Gained", $0.strokesGainedApproach())
                        )
                        .foregroundStyle(by: .value("Round Type", $0.roundType.rawValue))
                        
                        RuleMark(y: .value("Tour Average", 0))
                            .foregroundStyle(.primary)
                    }
                    .padding()
                    
                    
                    
                    Section {
                        StatTable(titleValuePairs: self.strokesGained)
                    } header: {
                        Text("Strokes Gained")
                            .font(.headline)
                    }
                    Section {
                        StatTable(titleValuePairs: self.approachStats)
                    } header: {
                        Text("Overall")
                            .font(.headline)
                    }
                    
                    
                    Section {
                        
                        DistanceAndLieFilter(distanceBounds: self.$distanceBounds, lies: $lies)
                        
                        StatTable(titleValuePairs: self.specificApproachStats)
                    } header: {
                        Text("Filtered")
                            .font(.headline)
                    }
                    
                    
                }
            }
            .animation(.easeInOut, value: self.distanceBounds)
            .animation(.easeInOut, value: self.lies)
        } label: {
            Text("Approach")
                .font(.title)
                .bold()
        }
        .padding()
    }
}

struct ApproachStatView_Previews: PreviewProvider {
    static var previews: some View {
        ApproachStatView(rounds: [Round.completeRoundExample1])
    }
}
