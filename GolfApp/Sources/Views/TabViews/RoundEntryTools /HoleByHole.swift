//
//  HoleByHole.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-28.
//

import SwiftUI

/// <#Description#>
struct HoleByHole: View {
  @Binding var golfer: Golfer
  @State var round: Round
  @Binding var path: NavigationPath
  @State var showRoundFinished: Bool = false

  private let shotPredictor = ShotPredictor() // TODO: implement a tighter 
  @State var holeNumber: Int
  @State private var isHoleSaved: [Bool] = .init(repeating: false, count: 18)

  @State private var isDeleteRound = false
  @State private var isRoundSetup = false

  @State private var isHoleValid: String?

  /// A state variable which holds a map to each shotIntermediate for each hole in the round
  @State private var shotList: [[ShotIntermediate]] = .init(repeating: [], count: 18)

  @State private var showScorecard = false

  @ViewBuilder
  var holeInfo: some View {
    let hole = round.tee.holeData[holeNumber - 1]
    HStack {
      Text("Par \(hole.par)")

      Divider()

      Text("\(hole.yardage.yards, format: .number) Yards")
      //TODO: fix this to a dependency on the settings if this application.

      Divider()

      Text("Hcp: \(hole.handicap)")
    }
  }

  var body: some View {

    let _ = Self._printChanges()

    VStack {
      Text("Hole \(holeNumber)")
        .bold()
        .font(.title)

      Divider()

      holeInfo
        .frame(maxHeight: 50)

      GroupBox {
        VStack {
          Grid(alignment: .center) {
            GridRow {
              Text("To Hole")
              Text("Lie")
              Text("At Hole")
              Text("Drop")
            }
            .bold()
            Divider()

            ForEach($shotList[self.holeNumber - 1]) { shot in
              GridRow {
                ShotElement(shot: shot, isFinal: self.$isHoleSaved[holeNumber - 1])
              }

            }

          }
          Button {
            self.addNextValueTo(holeNumber: holeNumber)
          } label: {
            Spacer()
            Label("Add Shot", systemImage: "plus.circle")
              .bold()
            Spacer()
          }
          .disabled(self.isHoleSaved[holeNumber - 1])
          .padding(.top, 3)

        }
        .padding(.vertical, 3)

      } label: {
        HStack {
          Label("Shot Entry", systemImage: "figure.golf")

          Spacer()

          if !shotList[holeNumber - 1].isEmpty {
            if isHoleSaved[holeNumber - 1] {
              Button {
                isHoleSaved[holeNumber - 1] = false
              } label: {
                Image(systemName: "pencil")
              }
            } else {
              Button {
                isHoleSaved[holeNumber - 1] = true
              } label: {
                Image(systemName: "checkmark")
              }
              .disabled(shotList[holeNumber - 1].isEmpty)

            }

            Button(role: .destructive) {
              self.shotList[holeNumber - 1].remove(
                at: self.shotList[holeNumber - 1].count - 1)
            } label: {
              Image(systemName: "delete.left")
            }
            .padding(.leading, 7)
            .disabled(shotList[holeNumber - 1].isEmpty)

          }
        }
      }
      .padding()

      Spacer()

      if let errorMessage = self.isHoleValid {
        VStack {
          Image(systemName: "exclamationmark.triangle")
            .imageScale(.large)
            .padding(.horizontal, 6)
            .padding(.bottom, 5)
          Text(errorMessage)

        }
        .padding(15)
        .background {
          RoundedRectangle(cornerRadius: 10, style: .continuous)
            .foregroundStyle(.red)
            .opacity(0.5)
        }

      }

      if self.round.isComplete {
        Button {
          self.showRoundFinished = true
        } label: {
          Label("Finish Round", systemImage: "checkmark")
        }
        .buttonStyle(.bordered)
        .disabled(!self.round.isComplete)
      }

    }
    .animation(.easeInOut, value: self.isHoleValid)
    .sheet(
      isPresented: self.$showRoundFinished,
      content: {
        RoundOverviewPage(
          golfer: self.$golfer, path: self.$path, showView: self.$showRoundFinished,
          round: self.round, isStat: false)
      }
    )

    .animation(.easeInOut, value: self.shotList[holeNumber - 1])
    .animation(.easeInOut, value: self.isHoleSaved[holeNumber - 1])
    .toolbar {

      ToolbarItem(placement: .navigationBarLeading) {

        Button(role: .destructive) {
          self.isDeleteRound = true
        } label: {
          Label("Restart Round", systemImage: "trash")
        }
        .confirmationDialog(
          "Cancel Round", isPresented: self.$isDeleteRound,
          actions: {
            Button(role: .destructive) {
              self.path.keepFirst()
            } label: {
              Text("Confirm")
            }

          },
          message: {
            Text("Your scores will be deleted")
          })

      }

      ToolbarItemGroup(placement: .bottomBar) {

        if holeNumber > 1 {
          Button {
            self.holeNumber -= 1

          } label: {
            Label("Last Hole", systemImage: "arrow.backward.circle")
          }
          .disabled(self.isHoleValid != nil)
          .font(.system(size: 25))

        }

        Spacer()

        Spacer()
        if holeNumber < 18 {
          Button {
            self.holeNumber += 1
          } label: {
            Label("Next Hole", systemImage: "arrow.forward.circle")
          }
          .disabled(self.isHoleValid != nil)
          .font(.system(size: 25))
        }

      }

      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          self.showScorecard = true
        } label: {
          Label("Scorecard", systemImage: "menucard")
        }
      }
    }
    .sheet(
      isPresented: self.$showScorecard,
      content: {
        ScorecardView(
          round: self.round, currentHole: self.$holeNumber, showView: self.$showScorecard)

      }
    )
    .navigationBarBackButtonHidden()
    .onChange(
      of: self.holeNumber,
      perform: { [holeNumber] newValue in

        if self.isHoleValid == nil {
          Task {
            await self.postShots(for: holeNumber)
          }
        }

      }
    )
    .onChange(of: shotList) { newShotList in
      self.isHoleValid = self.isShotsValid(holeNumber: self.holeNumber)

      if isHoleValid == nil {
        Task {
          await postShots(for: self.holeNumber)
        }
      }

    }

  }
}

extension HoleByHole {

  private func isShotsValid(holeNumber: Int) -> String? {
    return self.shotList[holeNumber - 1].is_valid()
  }

  private func addNextValueTo(holeNumber: Int) {
    if let lastShot = self.shotList[holeNumber - 1].last {
      self.shotList[holeNumber - 1].append(lastShot.getNextValue(shotPredictor: shotPredictor))
      
    } else {
      self.shotList[holeNumber - 1].append(ShotIntermediate.getFirstShotPrediction(hole: self.round.holes[holeNumber - 1]))
    }
    

  }

  /// Posts the shot intermediates for the given hole to the round.
  ///
  /// Calling this function will overwrite the current values in the shots for that particular hole in the round.
  ///
  /// - Parameter hole: The hole number we are posting shots for.
  private func postShots(for hole: Int) async {
    let intermediatesList = self.shotList[hole - 1]
    
    
    let shotsList = intermediatesList.prepareShots()
    self.round.updateHole(hole, with: shotsList)
    
  }
}

struct HHPreview: View {
  var holeNumber = 1

  var round = Round.emptyRoundExample1

  @State var golfer = Golfer.golfer

  @State var path = NavigationPath()

  var body: some View {

    NavigationStack {
      HoleByHole(golfer: $golfer, round: round, path: self.$path, holeNumber: holeNumber)
    }
  }
}


//MARK: Preview
#Preview {
  HHPreview()
}


struct NavigationStackRound: Hashable {
  let isFinal: Bool
  var round: Round

  init(round: Round) {
    self.isFinal = true
    self.round = round
  }

}
