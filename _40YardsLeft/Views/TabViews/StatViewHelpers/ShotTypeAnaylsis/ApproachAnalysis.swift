//
//  ApproachAnalysis.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-08-18.
//

import SwiftUI

struct ApproachAnalysis: View {
    let shots: [Shot]
    
    var strokesGained: (Double?, Int) {
        return (shots.strokesGained(ShotFilters.allApproach), shots.filter { $0.type == .approach }.count)
    }
    
    var successRate: (Double?, Int) {
        return (shots.greenPercentageFrom(range: .zero..<Distance.MAX_DISTANCE, lie: Lie.allCases), shots.filter { $0.type == .approach }.count)
    }
    
    var proximity: (Distance?, Int) {
        return (shots.approachProximityFrom(range: .zero..<Distance.MAX_DISTANCE, lie: Lie.allCases), shots.filter { $0.type == .approach }.count)
    }
    
    func proximityInRange(range: Range<Distance>) -> (Distance?, Int) {
        (shots.approachProximityFrom(range: range, lie: Lie.allCases), shots.filter { $0.type == .approach && range.contains( $0.startPosition.yardage) }.count)
    }
    
    func proximityInRangeWithLies(range: Range<Distance>, lies: [Lie]) -> (Distance?, Int) {
        (shots.approachProximityFrom(range: range, lie: lies), shots.filter { $0.type == .approach && range.contains( $0.startPosition.yardage) && lies.contains($0.startPosition.lie) }.count)
    }
    
    
    
    
    var body: some View {
        GroupBox {
            VStack {
                
                
                HStack {
                    Text("Strokes Gained:")
                        .font(.system(size: 25))
                        .bold()
                    Text("\(self.strokesGained.0 ?? 0, specifier: "%.1f")")
                        .font(.system(size: 25))
                        
                    
                }
                GroupBox {
                    Grid {
                        GridRow {
                            Text("Proximity")
                                .bold()
                            Text("Success Rate")
                                .bold()
                        }
                        
                        Divider()
                        
                        GridRow {
                            
                        }
                    }
                }
            }

        } label: {
            VStack (alignment: .center) {
                Text("Approach Detail View")
                    .font(.title)
                    .bold()
                Text("\(self.strokesGained.1) shots")
                    .font(.subheadline)
                
                Divider()
                    
            }
        }
    }
}


struct ApproachAnalysis_Previews: PreviewProvider {
    
    static var previews: some View {
        ApproachAnalysis(shots: Shot.exampleShotList)
            .padding()
    }
}
