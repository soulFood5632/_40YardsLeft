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
    @State private var navStack = [String]()
    
    
    var body: some View {
        NavigationStack(path: self.$navStack) {
            VStack {
                
                GroupBox {
                    VStack {
                        GolferView(golfer: golfer)
                        
                        HotStreak(golfer: golfer)
                            .font(.headline)
                    }
                    
                } label: {
                    Label("Welcome Back \(golfer.name)", systemImage: "hand.wave.fill")
                        .bold()
                        .font(.largeTitle)
                    
                }
                
                GroupBox {
                    //TODO: stat dashboard
                    NavigationLink() {
                        StatView()
                    } label: {
                        
                        Label("Analyze", systemImage: "chart.bar")
                            .bold()
                            .font(.title2)
                        
                    }
                    .buttonStyle(.bordered)
                }
                
                GroupBox {
                    //TODO: add things here
                    
                    NavigationLink {
                        RoundEntry(golfer: self.$golfer)
                    } label: {
                        
                        Label("Play", systemImage: "figure.golf")
                            .bold()
                            .font(.title2)
                        
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                GroupBox {
                    
                    ScrollView {
                        RoundViewList(golfer: self.$golfer)
                            .disabled(true)
                    }
                    NavigationLink {
                        RoundView(golfer: self.$golfer)
                    } label: {
                        
                        Label("View History", systemImage: "book")
                            .bold()
                            .font(.title2)
                        
                    }
                    .buttonStyle(.bordered)
                }
                


                
            }
            .padding()
            .toolbar {
                ToolbarItem (placement: .navigationBarLeading) {
                    NavigationMenu(golfer:
                                    $golfer)

                }
                
            }
            .toolbar {
                ToolbarItem (placement: .navigationBarTrailing) {
                    //TODO: add settings here.
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
            .preferredColorScheme(.dark)
    }
}
