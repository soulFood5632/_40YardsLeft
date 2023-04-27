//
//  IndividualButton.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-01.
//

import SwiftUI

struct IndividualButton: View {
    let buttonNumber: Int
    @Binding var activeHole: Int
    let round: Round
    
    var body: some View {
        
        ZStack {
            CenteredSquare()
                .fill(getFillColour())
                
            
            Text(buttonNumber.formatted())
                .font(.title)
        }
        .onTapGesture {
            self.activeHole = buttonNumber
        }
    }
    
    
    
    private func getFillColour() -> Color {
        if activeHole == buttonNumber {
            return .gray.opacity(0.6)
        }
        
        if round.isHoleFilled(self.buttonNumber) {
            return .green.opacity(0.6)
        }
        
        return .gray.opacity(0.3)
        
    }
}

struct IndividualButton_Previews: PreviewProvider {
    @State private static var buttonNumber = 1
    static var previews: some View {
        IndividualButton(buttonNumber: 1, activeHole: self.$buttonNumber, round: .emptyRoundExample1)
    }
}
