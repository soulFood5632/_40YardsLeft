//
//  Menu.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-13.
//

import SwiftUI

struct NavigationMenu: View {
    var body: some View {
        Menu {
            
            NavigationLink() {
                RoundEntry()
            } label: {
                Label("Add Round", systemImage: "plus")
            }
            
            NavigationLink() {
                RoundView()
            } label: {
                Label("Manage Rounds", systemImage: "pencil")
            }
            
            NavigationLink() {
                StatView()
            } label: {
                Label("Analyze Rounds", systemImage: "chart.dots.scatter")
            }
            
        } label: {
            Image(systemName: "ellipsis")
        }

        
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        NavigationMenu()
    }
}
