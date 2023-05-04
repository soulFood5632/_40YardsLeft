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
                        Text("Handicap")
                            .bold()
                        if let handicap = golfer.handicap {
                            Text("\(handicap, format: .number)")
                        } else {
                            //TODO: maybe fix
                            Text("No rounds")
                        }
                    }
                }
                
                GroupBox {
                    VStack {
                        //TODO: make year format
                        Text("Rounds") //TODO: imploment the correct filter
                            .bold()
                        Text("\(golfer.rounds.filter{ $0 == $0 }.count)")
                    }
                }
                
                
                GroupBox {
                    VStack {
                        Text("Scoring")
                            .bold()
                        if let scoringAverage = self.golfer.scoringAverage {
                            
                            Text(scoringAverage.toDecimalPlaces(1))
                        } else {
                            //TODO: Look into this
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
