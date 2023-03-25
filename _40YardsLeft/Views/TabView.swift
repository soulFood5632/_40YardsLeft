//
//  TabView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-24.
//

import SwiftUI

struct TabView: View {
    @State private var currentView: ViewScreens = .home
    var body: some View {
        Group {
            switch currentView {
            case .home:
                HomeView()
            case .roundEntry:
                RoundView()
            case .stats:
                StatView()
            }
        }
        .toolbar {
            ToolbarItemGroup (placement: .bottomBar) {
                HStack {
                    ImageIcon(systemName: "house", iconValue: .home, currentScreen: $currentView)
                    Divider()
                    ImageIcon(systemName: "figure.golfer", iconValue: .roundEntry, currentScreen: $currentView)
                    Divider()
                    ImageIcon(systemName: "figure.golfer", iconValue: .roundEntry, currentScreen: $currentView)
                }
            }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabView()
    }
}
