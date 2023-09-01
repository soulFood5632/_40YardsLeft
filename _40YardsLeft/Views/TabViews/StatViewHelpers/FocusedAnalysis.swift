//
//  FocusedAnalysis.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-08-17.
//

import SwiftUI

struct FocusedAnalysis: View {
    let round: Round
    
    var shots: [Shot] {
        return round.getShots().filter(self.focus.shotFilter)
    }
    
    var shotsWithHole: [(Shot, Int)] {
        var shotList = [(Shot, Int)]()
        let holes = round.holes
        
        for index in holes.indices {
            try! holes[index]
                .getSimplifiedShots()
                .filter(self.focus.shotFilter)
                .forEach{ shotData in
                shotList.append((shotData, index + 1))
                    print(index + 1)
            }

        }
        return shotList
    }
    let focus: AnalysisFocus
    
    var body: some View {
        
        ScrollView {
            switch focus {
            case .approach:
                ApproachAnalysis(shots: shots)
            case .chipping:
                ChippingAnalysisView(shots: shots)
            case .putting:
                PuttingDetailView(shots: shots)
            case .tee:
                DrivingDetailView(shots: shots)
            }
            
            GroupBox {
                VStack {
                    ForEach(shotsWithHole, id: \.0) { shot in
                        ShotByShotAnalysis(shot: shot)
                            .padding(5)
                            .background {
                                Rectangle()
                                    .stroke(lineWidth: 2)
                            }
                        
                            .padding(.horizontal, 1)
                        
                    }
                }
            } label: {
                Text("Shot by Shot")
                    .font(.title2)
                    .bold()
            }
            .padding(.top, 10)
            .padding([.horizontal, .bottom], 4)
            
            
        }
    }
    
}

extension AnalysisFocus {
    var shotFilter: (Shot) -> Bool {
        switch self {
        case .approach:
            return { $0.type == .approach }
        case .chipping:
            return { $0.type == .chip_pitch }
        case .putting:
            return { $0.type == .putt }
        case .tee:
            return { $0.type == .drive }
        }
    }
}

struct FocusedAnalysis_Previews: PreviewProvider {
    static var previews: some View {
        FocusedAnalysis(round: Round.completeRoundExample1, focus: .approach)
    }
}
