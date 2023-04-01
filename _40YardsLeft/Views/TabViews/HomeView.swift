//
//  HomeView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-24.
//

import SwiftUI

struct HomeView: View {
    @Binding var golfer: Golfer
    
    var body: some View {
        NavigationView {
            VStack {
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
                                        Text("\(golfer.handicap)")
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
                
                NavigationLink {
                    RoundView()
                } label: {
                    Text("add Round")
                }
            }
            
            
            
        }
    }
    
    
}

extension Date {
    static func getCurrentYear() -> Int {
        return getYearFromDate(.now)
        //TODO: Imploment this method
    }
    
    static func getYearFromDate(_ date: Date) -> Int {
        return 2023
    }
}

struct HomeView_Previews: PreviewProvider {
    @State static private var golfer = Golfer.golfer
    static var previews: some View {
        HomeView(golfer: Self.$golfer)
    }
}
