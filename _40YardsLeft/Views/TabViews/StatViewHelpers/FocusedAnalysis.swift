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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
}

struct FocusedAnalysis_Previews: PreviewProvider {
    static var previews: some View {
        FocusedAnalysis(shots: Round.completeRoundExample1.getShots(), focus: .approach)
    }
}
