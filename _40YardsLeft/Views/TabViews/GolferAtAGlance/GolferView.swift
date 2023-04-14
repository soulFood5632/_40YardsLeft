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
                        
                        Text("\(golfer.handicap, format: .number)")
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
                        //TODO: Implement average score and make only 1 digit
                        Text("72.8")
                        
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
