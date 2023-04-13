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
        GroupBox {
            HStack {
                GroupBox {
                    let currentYear = Date.getCurrentYear()
                    VStack (alignment: .leading) {
                        Grid {
                            GridRow {
                                Text("Handicap:")
                                    .bold()
                                //TODO: make to only 1 digit
                                Text("\(golfer.handicap, format: .number)")
                            }
                            
                            GridRow {
                                Text("Rounds in \(currentYear):") //TODO: imploment the correct filter
                                    .bold()
                                Text("\(golfer.rounds.filter{ $0 == $0 }.count)")
                            }
                            
                            GridRow {
                                Text("Average Score:")
                                    .bold()
                                //TODO: Imploment average score and make only 1 digit
                                Text("72.8")
                            }
                        }
                    }
                    .font(.title3)
                }
                
                
                
                
                
            }
        } label: {
            Label("Welcome Back \(golfer.name)", systemImage: "hand.wave.fill")
                .bold()
                .font(.title)
        }
        .padding()
    }
}

struct GolferView_Previews: PreviewProvider {
    static var previews: some View {
        GolferView(golfer: Golfer.golfer)
    }
}
