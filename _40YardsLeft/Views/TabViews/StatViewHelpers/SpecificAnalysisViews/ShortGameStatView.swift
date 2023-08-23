//
//  ShortGameStatView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-08-21.
//

import SwiftUI
import Charts

struct ShortGameStatView: View {
    let rounds: [Round]
    
    @State private var distanceBounds: Range<Distance> = Distance(yards: 10)..<Distance(yards: 50)
    @State private var lies: [Lie] = [.fairway, .rough]
    @State private var insideProxValue: Distance = .feet(8)
    
    
    var shotFilter: (Shot) -> Bool {
        return { shot in
            return distanceBounds.contains(shot.startPosition.yardage) && lies.contains(shot.startPosition.lie) && shot.type == .chip_pitch
            
        }
    }
    
    var strokesGained: [DisplayStat<Double, Int>] {
        let perShot = rounds.strokesGained(for: .chip_pitch).0 / Double(rounds.strokesGained(for: .chip_pitch).1)
        
        let perRound = rounds.strokesGained(for: .chip_pitch ).0 / Double(rounds.strokesGained(for: .chip_pitch).2)
        
        return [
            DisplayStat(name: "Strokes Gained Per Shot", value: perShot.isNaN ? 0 : perShot, numOfSamples: rounds.strokesGained(for: .chip_pitch).1, formatter: "%.2f"),
            DisplayStat(name: "Strokes Gained Per Round", value: perRound.isNaN ? 0 : perRound ,numOfSamples: rounds.count, formatter: "%.2f"),
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
    
    var chipStats: [DisplayStat<Double, Int>] {
        
        let upAndDowns = Double(rounds.upAndDowns().0) / Double(rounds.upAndDowns().1) * 100
        
        let fairwaySave = Double(rounds.saves(for: [.fairway]).0) / Double(rounds.saves(for: [.fairway]).1) * 100
        
        let roughSave = Double(rounds.saves(for: [.rough]).0) / Double(rounds.saves(for: [.rough]).1) * 100
        
        let sandSave = Double(rounds.saves(for: [.bunker]).0) / Double(rounds.saves(for: [.bunker]).1) * 100
        
        let twoChips = Double(rounds.twoChipOccurances().0) / Double(rounds.twoChipOccurances().1)
        
        return [
            DisplayStat(name: "Up and Downs", value: upAndDowns.isNaN ? 0 : upAndDowns, numOfSamples: rounds.upAndDowns().1, formatter: "%.1f", isPercent: true),
            DisplayStat(name: "Fairway Save", value: fairwaySave.isNaN ? 0 : fairwaySave, numOfSamples: rounds.saves(for: [.fairway]).1, formatter: "%.1f", isPercent: true),
            DisplayStat(name: "Rough Save", value: roughSave.isNaN ? 0 : roughSave, numOfSamples: rounds.saves(for: [.rough]).1, formatter: "%.1f", isPercent: true),
            DisplayStat(name: "Sand Save", value: sandSave.isNaN ? 0 : sandSave, numOfSamples: rounds.saves(for: [.bunker]).1, formatter: "%.1f", isPercent: true),
            DisplayStat(name: "Proximity", value: shots.proximityFrom(ShotFilters.allShortGame)?.feet ?? 0, numOfSamples: shots.filter(ShotFilters.allShortGame).count, formatter: "%.1f"),
            DisplayStat(name: "Inside \(insideProxValue.feet) Feet", value: (shots.percentageInsideProx(maxDistance: self.insideProxValue, shotType: .chip_pitch) ?? 0) * 100, numOfSamples: shots.filter(ShotFilters.allShortGame).count, formatter: "%.1f", isPercent: true),
            
            DisplayStat(name: "Two Chip %", value: twoChips.isNaN ? 0 : twoChips, numOfSamples: rounds.twoChipOccurances().1, formatter: "%.1f", isPercent: true),
        ]
    }
    
    var specificChipStats: [DisplayStat<Double, Int>] {
        
        let strokesGained = shots.strokesGained { self.distanceBounds.contains($0.startPosition.yardage) && self.lies.contains($0.startPosition.lie) && $0.type == .chip_pitch }
        let totalShots = shots.filter {self.distanceBounds.contains($0.startPosition.yardage) && self.lies.contains($0.startPosition.lie) && $0.type == .chip_pitch }.count
        
        if totalShots == 0 {
            return [
                DisplayStat(name: "Strokes Gained", value: 0, numOfSamples: totalShots, formatter: "%.2f"),
                DisplayStat(name: "Strokes To Hole Out", value: rounds.strokesToHoleOut(self.shotFilter).0 ?? 0, numOfSamples: rounds.strokesToHoleOut(self.shotFilter).1, formatter: "%.2f"),
                DisplayStat(name: "Save %", value: 0, numOfSamples: rounds.saves(filter: self.shotFilter).1, formatter: "%.1f", isPercent: true),

                DisplayStat(name: "Proximity", value: shots.approachProximityFrom(range: self.distanceBounds, lie: self.lies, shotType: .chip_pitch)?.feet ?? 0, numOfSamples: totalShots, formatter: "%.1f"),
                DisplayStat(name: "Inside \(self.insideProxValue.feet) Feet", value: (shots.percentageInsideProx(maxDistance: self.insideProxValue, range: self.distanceBounds, lie: self.lies, shotType: .chip_pitch) ?? 0) * 100, numOfSamples: totalShots, formatter: "%.1f", isPercent: true),
            ]
        }
        return [
            
            
            DisplayStat(name: "Strokes Gained", value: Double(strokesGained) / Double(totalShots), numOfSamples: totalShots, formatter: "%.2f"),
            
            DisplayStat(name: "Strokes To Hole Out", value: rounds.strokesToHoleOut(self.shotFilter).0 ?? 0, numOfSamples: rounds.strokesToHoleOut(self.shotFilter).1, formatter: "%.2f"),
            DisplayStat(name: "Save %", value: Double(rounds.saves(filter: self.shotFilter).0) / Double(rounds.saves(filter: self.shotFilter).1) * 100, numOfSamples: rounds.saves(filter: self.shotFilter).1, formatter: "%.1f", isPercent: true),
            
            DisplayStat(name: "Proximity", value: shots.approachProximityFrom(range: self.distanceBounds, lie: self.lies, shotType: .chip_pitch)?.feet ?? 0, numOfSamples: totalShots, formatter: "%.1f"),
            DisplayStat(name: "Inside \(self.insideProxValue.feet) Feet", value: (shots.percentageInsideProx(maxDistance: self.insideProxValue, range: self.distanceBounds, lie: self.lies, shotType: .chip_pitch) ?? 0) * 100, numOfSamples: totalShots, formatter: "%.1f", isPercent: true),

            
        ]
    }
    var body: some View {
        GroupBox {
            VStack {
                
                List {
                    
                    Chart(rounds) {
                        PointMark(
                            x: .value("Date", $0.date),
                            y: .value("Strokes Gained", $0.strokesGainedShortGame())
                        )
                        .foregroundStyle(by: .value("Round Type", $0.roundType.rawValue))
                        
                        RuleMark(y: .value("Tour Average", 0))
                            .foregroundStyle(.primary)
                    }
                    .padding()
                    
                    let distanceBinding = Binding<Double> {
                        self.insideProxValue.feet
                    } set: { newValue in
                        if newValue > 100 {
                            self.insideProxValue = .feet(100)
                        } else if newValue < 0 {
                            self.insideProxValue = .zero
                        } else {
                            self.insideProxValue = .feet(newValue)
                        }
                    }

                    Section {
                        StatTable(titleValuePairs: self.strokesGained)
                    } header: {
                        Text("Strokes Gained")
                            .font(.headline)
                    }
                    
                    Section {
                        GroupBox {
                            
                            Slider(value: distanceBinding, in: 0...30, step: 1) {
                                Text("Inside Distance Slider")
                            } minimumValueLabel: {
                                Text("0")
                                    .fontWeight(.thin)
                            } maximumValueLabel: {
                                Text("30")
                                    .fontWeight(.thin)
                            }
                        } label: {
                            HStack {
                                Text("Distance Slider")
                                    .font(.headline)
                                
                                Text("\(self.insideProxValue.feet, specifier: "%.0f")")
                                    .font(.subheadline)
                            }
                        }
                    }
                    
                    Section {
                        StatTable(titleValuePairs: self.chipStats)
                    } header: {
                        Text("Overall")
                            .font(.headline)
                    }
                    
                    
                    Section {
                        
                        DistanceAndLieFilter(distanceBounds: self.$distanceBounds, lies: $lies)
                        
                        StatTable(titleValuePairs: self.specificChipStats)
                    } header: {
                        Text("Filtered")
                            .font(.headline)
                    }
                    
                    
                }
            }
            .animation(.easeInOut, value: self.distanceBounds)
            .animation(.easeInOut, value: self.lies)
        } label: {
            Text("Short Game")
                .font(.title)
                .bold()
        }
        .padding()
        
    }
}

struct ShortGameStatView_Previews: PreviewProvider {
    static var previews: some View {
        ShortGameStatView(rounds: [Round.completeRoundExample1])
    }
}
