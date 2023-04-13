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
        NavigationStack {
            VStack {
                
                
                
                GolferView(golfer: golfer)
                    .navigationTitle("Home")
                    
                RoundUpdateView(golfer: golfer)
                NavigationLink {
                    RoundEntry()
                } label: {
                    Text("add Round")
                }
            }
            .toolbar {
                ToolbarItem (placement: .navigationBarLeading) {
                    NavigationMenu()

                }
                
            }
            .toolbar {
                ToolbarItem (placement: .navigationBarTrailing) {
                    Text("Settings")
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
