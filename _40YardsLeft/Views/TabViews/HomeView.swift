//
//  HomeView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-24.
//

import SwiftUI

//TODO: think about navigation stack advantages
//TODO: navigation titles?

struct HomeView: View {
    @Binding var golfer: Golfer
    
    @State private var isAddRound = false
    @State private var isStatView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                
                GroupBox {
                    VStack {
                        GolferView(golfer: golfer)
                        
                        HotStreak(golfer: golfer)
                    }
                        
                } label: {
                    Label("Welcome Back \(golfer.name)", systemImage: "hand.wave.fill")
                        .bold()
                        .font(.title)
                    
                }
                
                HStack {
                     
                        
                    
                    
                    
                    NavigationLink {
                        StatView()
                    } label: {
                        
                        Label("Analyze", systemImage: "chart.bar")
                            .bold()
                            .font(.title)
                        
                    }
                    .buttonStyle(.bordered)
                    .navigationTitle("Home")
                    
                    
                    NavigationLink {
                        RoundView(golfer: self.$golfer)
                    } label: {
                        
                        Label("History", systemImage: "book")
                            .bold()
                            .font(.title)
                        
                    }
                    .buttonStyle(.bordered)
                    
                    
                    
                    
                }
                
                NavigationLink {
                    RoundEntry(golfer: self.$golfer)
                } label: {
                    Spacer()
                    Label("Play", systemImage: "figure.golf")
                        .bold()
                        .font(.title)
                    Spacer()
                }
                .buttonStyle(.borderedProminent)

                
                    
                
                    
                
                
                
                
                
            }
            
//            .navigationTitle("Home")
            .padding()
            .toolbar {
                ToolbarItem (placement: .navigationBarLeading) {
                    NavigationMenu(golfer:
                                    $golfer)

                }
                
            }
            .toolbar {
                ToolbarItem (placement: .navigationBarTrailing) {
                    Text("Settings")
                }
            }
            .navigationBarBackButtonHidden()

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
