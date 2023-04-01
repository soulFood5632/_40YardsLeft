//
//  HoleButtons.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-01.
//

import SwiftUI

struct HoleButtons: View {
    let round: Round
    @Binding var holeNumber: Int
    var body: some View {
        VStack {
            HStack {
                ForEach(1..<7) { index in
                    IndividualButton(buttonNumber: index, activeHole: self.$holeNumber, round: round)
                        .padding(.horizontal, 3)
                }
            }
            HStack {
                ForEach(7..<13) { index in
                    IndividualButton(buttonNumber: index, activeHole: self.$holeNumber, round: round)
                }
            }
            HStack {
                ForEach(13..<19) { index in
                    IndividualButton(buttonNumber: index, activeHole: self.$holeNumber, round: round)
                }
            }
        }
        .padding(.horizontal)
    }
}



struct HoleButtons_Previews: PreviewProvider {
    @State private static var hole = 10
    
    static var previews: some View {
        HoleButtons(round: .example1, holeNumber: self.$hole)
    }
}
