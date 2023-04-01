//
//  ScorecardView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-31.
//

import SwiftUI

struct ScorecardView: View {
    let round: Round
    
    @Binding var currentHole: Int
    
    var body: some View {
        HoleButtons(round: round, holeNumber: self.$currentHole)
    }
}


struct ScorecardView_Previews: PreviewProvider {
    @State private static var currentHole = 10
    static var previews: some View {
        ScorecardView(round: .example1, currentHole: self.$currentHole)
    }
}
