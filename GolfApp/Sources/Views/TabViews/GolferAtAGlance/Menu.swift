//
//  Menu.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-13.
//

import SwiftUI

struct NavigationMenu: View {
  @Binding var golfer: Golfer
  @Binding var navStack: NavigationPath
  var body: some View {
    Menu {

      NavigationLink(value: ScreenState.play) {
        Label("Add Round", systemImage: "plus")
      }

      NavigationLink(value: ScreenState.history) {
        Label("Manage Rounds", systemImage: "pencil")
      }

      NavigationLink(value: ScreenState.stats) {
        Label("Analyze Rounds", systemImage: "chart.dots.scatter")
      }

    } label: {
      Image(systemName: "ellipsis")
    }

  }
}

struct Menu_Previews: PreviewProvider {
  @State private static var golfer = Golfer.golfer
  @State private static var navStack = NavigationPath()
  static var previews: some View {
    NavigationMenu(golfer: self.$golfer, navStack: $navStack)
  }
}
