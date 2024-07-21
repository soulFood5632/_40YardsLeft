//
//  RoundView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-24.
//

import SwiftUI

struct RoundView: View {
  @Binding var golfer: Golfer
  @Binding var path: NavigationPath
  var body: some View {

    VStack {

      Group {
        GroupBox {
          GolferView(golfer: golfer)
        } label: {
          Label("Overview", systemImage: "globe")
        }
        .frame(maxHeight: 200)

        GroupBox {
          if golfer.rounds.isEmpty {
            VStack {
              Text("You haven't posted a round yet")
                .bold()
                .padding(.bottom, 1)
              Button {
                withAnimation {
                  path.keepFirst()
                  path.append(ScreenState.play)
                }
              } label: {
                Text("Start Your First Round")
              }
            }
            .animation(.easeInOut, value: self.golfer.rounds)
          } else {
            RoundViewList(golfer: $golfer, path: self.$path)
          }

        } label: {
          Label("History", systemImage: "list.bullet")
          Divider()
        }
      }
      Spacer()

    }
    .padding(.horizontal)
    .navigationTitle("Rounds")
    .navigationBarBackButtonHidden()

  }
}

struct RoundView_Previews: View {

  @State private var golfer = Golfer.golfer
  @State private var navStack = NavigationPath()
  var body: some View {
    RoundView(golfer: $golfer, path: $navStack)
  }
}

#Preview {
  RoundView_Previews()
}
