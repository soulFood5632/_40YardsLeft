//
//  StrokesGainedGraph.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-05-14.
//

import SwiftUI
import Charts

struct StrokesGainedData : Identifiable {
    var id: UUID = UUID()
    
    var approach: Double {
        shots.strokesGained(ShotFilters.allApproach)
    }
    var chipping: Double {
        shots.strokesGained(ShotFilters.allShortGame)
    }
    var other: Double {
        shots.strokesGained(ShotFilters.allOther)
    }
    var putting: Double {
        shots.strokesGained(ShotFilters.allPutts)
    }
    var tee: Double {
        shots.strokesGained(ShotFilters.allTeeShots)
    }
    
    var approachString: String {
        shots.strokesGained(ShotFilters.allApproach).toDecimalPlaces(1)
    }
    var chippingString: String {
        shots.strokesGained(ShotFilters.allShortGame).toDecimalPlaces(1)
    }
    var otherString: String {
        shots.strokesGained(ShotFilters.allOther).toDecimalPlaces(1)
    }
    var puttingString: String {
        shots.strokesGained(ShotFilters.allPutts).toDecimalPlaces(1)
    }
    var teeString: String {
        shots.strokesGained(ShotFilters.allTeeShots).toDecimalPlaces(1)
    }
    
    var stringPairs: [String: Double] {
        [
            "Approach" : self.approach,
            "Chipping" : self.chipping,
            "Other" : self.other,
            "Putting" : self.putting,
            "Tee" : self.tee,
        ]
    }
    
    let shots: [Shot]
}

struct StrokesGainedGraph: View {
    let strokesGainedData: StrokesGainedData
    @Binding var focus: AnalysisFocus
    private var strokesGainedTable: [StrokesGainedData] { [strokesGainedData] }
    
    
    
    var body: some View {
        
       
            
            
            
            
            Chart {
                
                
                ForEach(strokesGainedData.stringPairs.map { ($0.key, $0.value) }.sorted(by: { $0.0 < $1.0 }), id: \.0) { nameValuePair in
                    BarMark(
                        x: .value("Shot Type", nameValuePair.0),
                        y: .value("Shots Gained", nameValuePair.1)
                    )
                    .foregroundStyle(nameValuePair.0 == focus.rawValue ? .primary : .secondary)
                    
                }
            }
            
            
            
        
        
    }
}

struct StrokesGainedGraph_Previews: PreviewProvider {
    
    static let shots = try! Round.completeRoundExample1.holes.randomElement()!.getSimplifiedShots()
    
    @State static var focus: AnalysisFocus = .approach
    static var previews: some View {
        StrokesGainedGraph(strokesGainedData: StrokesGainedData(shots: shots), focus: $focus)
            .padding()
    }
}
