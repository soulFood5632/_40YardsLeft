//
//  StrokesGainedGraph.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-05-14.
//

import SwiftUI
import Charts

struct StrokesGainedGraph: View {
    let shots: [Shot]
    var body: some View {
        Chart {
            let strokesGainedList = [
                "Tee": shots.strokesGained(ShotFilters.allTeeShots),
                "Approach":
                shots.strokesGained(ShotFilters.allApproach),
                "Chipping":
                shots.strokesGained(ShotFilters.allShortGame),
                "Putting":
                shots.strokesGained(ShotFilters.allPutts),
                "Other":
                    shots.strokesGained(ShotFilters.allOther)
            ]
            
            ForEach(strokesGainedList.map { ($0.key, $0.value) }.sorted(by: { $0.0 < $1.0 }), id: \.0) { nameValuePair in
                BarMark(
                    x: .value("Shot Type", nameValuePair.0),
                    y: .value("Shots Gained", nameValuePair.1)
                )
                //TODO: complete annotations here. 
//                .annotation(position: .top) {
//                    Text(String(nameValuePair.1))
//                }
                .foregroundStyle(nameValuePair.1 < 0 ? .red : .green)
            }
        }
        
    }
}

struct StrokesGainedGraph_Previews: PreviewProvider {
    
    static let shots = try! Round.completeRoundExample1.holes.randomElement()!.getSimplifiedShots()
    static var previews: some View {
        StrokesGainedGraph(shots: shots)
            .padding()
    }
}
