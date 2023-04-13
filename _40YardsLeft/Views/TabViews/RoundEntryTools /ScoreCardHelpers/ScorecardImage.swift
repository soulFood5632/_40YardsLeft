//
//  ScorecardImage.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-02.
//

import SwiftUI

struct ScorecardImage: View {
    let round: Round
    var body: some View {
        VStack {
            Grid {
                GridRow {
                    
                    ForEach(1...9) { holeNumber in
                        Text("\(holeNumber)")
                            .bold()
                    }
                    Text("Out")
                        .bold()
                }
                
                
                
                GridRow {
                    ForEach(1...9) { holeNumber in
                        Text("\(round.holes[holeNumber - 1].holeData.par)")
                        
                        
                    }
                    
                    Text("\(round.frontNinePar)")
                    
                }
                
                GridRow {
                    
                    ForEach(1...9) { holeNumber in
                        let score = round.holes[holeNumber - 1].score
                        EmptyIfZeroText(value: score)
                            .foregroundColor(round.holes[holeNumber - 1].getColourFromScore())
                        
                    }
                    
                    EmptyIfZeroText(value: round.frontNineScore)
                    
                }
                
                Divider()
                
                
                
                GridRow {
                    ForEach(10...18) { holeNumber in
                        Text("\(holeNumber)")
                            .bold()
                    }
                    Text("In")
                        .bold()
                }
                
                GridRow {
                    ForEach(10...18) { holeNumber in
                        Text("\(round.holes[holeNumber - 1].holeData.par)")
                        
                    }
                    
                    Text("\(round.frontNinePar)")
                    
                }
                
                GridRow {
                    ForEach(10...18) { holeNumber in
                        let score = round.holes[holeNumber - 1].score
                        EmptyIfZeroText(value: score)
                            .foregroundColor(round.holes[holeNumber - 1].getColourFromScore())
                        
                    }
                    EmptyIfZeroText(value: round.backNineScore)
                }
                
            }
            
            
            
            
            
            
            if round.isComplete {
                VStack {
                    Text("\(round.roundScore)")
                        .font(.title)
                        .bold()
                    Text("(\(round.scoreToPar))")
                        .font(.subheadline)
                }
            } else {
                HStack {
                    //TODO: fix this this mechanism to get colour
                    Text("\(round.scoreToPar)")
                    Text("Through \(round.numberOfHolesEntered())")
                }
            }
            //TODO: have the par update with the amount of holes played
            
            
            
            
        }
    }
}

struct EmptyIfZeroText : View {
    let value: Int
    var body: some View {
        if value == 0 {
            Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
        } else {
            Text("\(value)")
        }
    }
}

struct ScorecardImage_Previews: PreviewProvider {
    static var previews: some View {
        ScorecardImage(round: Round.example1)
    }
}
