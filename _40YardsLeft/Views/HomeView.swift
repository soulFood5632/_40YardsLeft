//
//  HomeView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-24.
//

import Charts
import SwiftUI

//TODO: think about navigation stack advantages
//TODO: navigation titles?

struct HomeView: View {
  @State var golfer: Golfer
  @Binding var path: NavigationPath

  var body: some View {

    ZStack {

      RadialBackground()

      VStack {

        GroupBox {
          VStack {
            GolferView(golfer: golfer)

            HotStreak(golfer: golfer)
              .font(.headline)

            Button {
              self.path.append(ScreenState.play)
            } label: {

              Label("Play Golf", systemImage: "figure.golf")
                .bold()
                .font(.title2)
            }
            .buttonStyle(.borderedProminent)
          }

        } label: {
          Label("Welcome Back", systemImage: "hand.wave.fill")
            .bold()
            .font(.largeTitle)

        }

        GroupBox {

          NavigationLink(value: ScreenState.stats) {

            Label("Analyze", systemImage: "chart.bar")
              .bold()
              .font(.title2)

          }
          .buttonStyle(.bordered)
          .disabled(self.golfer.rounds.isEmpty)
        }

        GroupBox {

          RoundViewList(golfer: self.$golfer, path: self.$path)

          NavigationLink(value: ScreenState.history) {
            Label("View History", systemImage: "book")
              .bold()
              .font(.title2)
          }
          .disabled(self.golfer.rounds.isEmpty)

        }

      }
      .padding()
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          NavigationMenu(
            golfer:
              $golfer, navStack: $path)

        }

      }
      .navigationDestination(for: ScreenState.self) { newState in

        switch newState {

          case .history:
            RoundView(golfer: self.$golfer, path: self.$path)
              .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                  GoHome(path: $path)
                }
              }
          case .play:
            RoundEntry(golfer: self.$golfer, path: self.$path)
          case .stats:
            StatView(path: self.$path, golfer: self.golfer)
              .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                  GoHome(path: $path)
                }
              }
          case .profile:
            ProfileView(golfer: self.golfer, path: self.$path)
              .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                  GoHome(path: $path)
                }
              }

        }

      }
      .navigationBarBackButtonHidden()
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            self.path.append(ScreenState.profile)
          } label: {
            Image(systemName: "gear.badge")
          }

        }
      }
      .navigationDestination(for: [Round].self) { roundList in
        StatAnalysisView(rounds: roundList)
      }
    }

  }

}

struct StatDashboard: View {
  let randomNumber: Int
  let golfer: Golfer

  var body: some View {

    let _ = Self._printChanges()

    if randomNumber < 20 && self.golfer.rounds.count >= 2 {
      Chart(self.golfer.rounds) {
        PointMark(
          x: .value("Date", $0.date),
          y: .value("Score", $0.roundScore)
        )
        .foregroundStyle(by: .value("Round Type", $0.roundType.rawValue))

      }
      .chartXAxisLabel("Date")
      .chartYAxisLabel("Score")

    } else if randomNumber < 40 {
      Chart(self.golfer.rounds) {
        PointMark(
          x: .value("Date", $0.date),
          y: .value("Tee Shot Strokes Gained", $0.strokesGainedTee())
        )
        .foregroundStyle(by: .value("Round Type", $0.roundType.rawValue))
      }

      .chartXAxisLabel("Date")
      .chartYAxisLabel("Tee Shot Strokes Gained")

    } else if randomNumber < 60 {
      Chart(self.golfer.rounds) {
        PointMark(
          x: .value("Date", $0.date),
          y: .value("Putting Strokes Gained", $0.strokesGainedPutting())
        )
        .foregroundStyle(by: .value("Round Type", $0.roundType.rawValue))
      }
      .chartXAxisLabel("Date")
      .chartYAxisLabel("Putting Strokes Gained")

    } else if randomNumber < 80 {
      Chart(self.golfer.rounds) {
        PointMark(
          x: .value("Date", $0.date),
          y: .value("Short Game Strokes Gained", $0.strokesGainedShortGame())
        )
        .foregroundStyle(by: .value("Round Type", $0.roundType.rawValue))
      }
      .chartXAxisLabel("Date")
      .chartYAxisLabel("Short Game Gained")
    } else {
      Chart(self.golfer.rounds) {
        PointMark(
          x: .value("Date", $0.date),
          y: .value("Approach Strokes Gained", $0.strokesGainedApproach())
        )
        .foregroundStyle(by: .value("Round Type", $0.roundType.rawValue))
      }
      .chartXAxisLabel("Date")
      .chartYAxisLabel("Approach Strokes Gained")
    }
  }
}

enum ScreenState {
  case play
  case history
  case stats
  case profile
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
  @State private static var path = NavigationPath()
  static var previews: some View {
    NavigationStack(path: $path) {
      HomeView(golfer: Self.golfer, path: self.$path)
        .preferredColorScheme(.dark)
    }
  }
}
