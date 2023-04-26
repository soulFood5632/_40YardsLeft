//
//  RoundInfo.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-14.
//

import SwiftUI

struct RoundInfo: View {
    let round: Round
    var body: some View {
        //TODO: make tee name bold
        Text(round.tee.name + " | \(round.tee.yardage.yards) | \(round.tee.rating), \(round.tee.slope)")
        
        //TODO: combine these elements into a single row of text
        Text("\(round.roundScore) (\(round.scoreToPar))")
            .bold()
        
        Text("In: \(round.backNineScore)")
        
        Text("Out: \(round.frontNineScore)")
        
 
    }
}



struct RoundInfo_Previews: PreviewProvider {
    static var previews: some View {
        Menu {
            RoundInfo(round: Round.emptyRoundExample1)
        } label: {
            Text("Click Me")
        }
    }
}
