//
//  TabView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-24.
//

import SwiftUI

struct UserView: View {
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            RoundView()
                .tabItem {
                    Label("Add Round", systemImage: "figure.golf")
                }
            StatView()
                .tabItem {
                    Label("Analysis", systemImage: "chart.bar")

                }
                
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
