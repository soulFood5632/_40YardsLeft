//
//  GolferView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-13.
//

import SwiftUI

struct GolferView: View {
    let golfer: Golfer
    var body: some View {
        
        HStack {
            
            
            HStack {
                
                GroupBox {
                    VStack {
                        Text("Low Round")
                            .bold()
                        if let minScore = golfer.rounds.map { $0.roundScore }.min() {
                            Text("\(minScore, format: .number)")
                        } else {
                            Text("No rounds")
                        }
                    }
                }
                
                GroupBox {
                    VStack {
                        
                        Text("Rounds")
                            .bold()
                        // future deployment last year rounds. 
                        Text("\(golfer.rounds.filter{ $0 == $0 }.count)")
                    }
                }
                
                
                GroupBox {
                    VStack {
                        Text("Scoring")
                            .bold()
                        if let scoringAverage = self.golfer.rounds.scoringAverage() {
                            
                            Text(scoringAverage.toDecimalPlaces(1))
                        } else {
                            Text("No Rounds")
                        }
                        
                    }
                }
                
                
            }
            
        }
        
        
    }
}



struct GolferView_Previews: PreviewProvider {
    static var previews: some View {
        GolferView(golfer: Golfer.golfer)
    }
}
