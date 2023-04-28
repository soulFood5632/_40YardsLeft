//
//  HomeView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-24.
//

import SwiftUI

struct HomeView: View {
    @Binding var golfer: Golfer
    
    @State private var isAddRound = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                
                GroupBox {
                    GolferView(golfer: golfer)
                        .navigationTitle("Home")
                } label: {
                    Label("Welcome Back \(golfer.name)", systemImage: "hand.wave.fill")
                        .bold()
                        .font(.title)
                }
                .padding(.horizontal)
                .frame(maxHeight: 200)
                    
                GroupBox {
                    HotStreak(golfer: golfer)
                    Button {
                        isAddRound = true
                    } label: {
                        Text("Start Round")
                    }
                    .buttonStyle(.borderedProminent)
                    .navigationDestination(isPresented: self.$isAddRound) {
                        RoundEntry(golfer: self.$golfer)
                    }
                } label: {
                    
                }
                
            }
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
