//
//  FocusedAnalysis.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-08-17.
//

import SwiftUI

struct FocusedAnalysis: View {
    let shots: [Shot]
    let focus: AnalysisFocus
    var body: some View {
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
    }
    
}

struct FocusedAnalysis_Previews: PreviewProvider {
    static var previews: some View {
        FocusedAnalysis(shots: Round.completeRoundExample1.getShots(), focus: .approach)
    }
}
