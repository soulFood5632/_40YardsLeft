//
//  ScorecardImage.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-02.
//

import SwiftUI

struct ScorecardImage: View {
  let round: Round
  var body: some View {

    //TODO: fix this bug, compile time typechecking error.
    VStack {
      Grid {
        GridRow {

          ForEach(1...9) { holeNumber in
            Text("\(holeNumber)")
              .bold()
          }
          Text("Out")
            .bold()
        }

        ScoreAndParGridElements(holes: self.round.holes.keepFirst(9))

        Divider()

        GridRow {
          ForEach(10...18) { holeNumber in
            Text("\(holeNumber)")
              .bold()
          }
          Text("In")
            .bold()
        }

        ScoreAndParGridElements(holes: self.round.holes.getLast(9))

      }
      .padding(.bottom, 5)

      if round.isComplete {
        HStack {
          Text("\(round.roundScore)")
            .font(.title3)
            .bold()
          Text("(\(round.scoreToPar))")
            .font(.subheadline)
        }
      } else {
        HStack {
          //TODO: fix this this mechanism to get colour
          Text("\(round.scoreToPar)")
            .foregroundColor(round.colourFromScoreToPar())

          Text("Through \(round.numberOfHolesEntered())")
        }
      }
      //TODO: have the par update with the amount of holes played

    }
  }
}

struct ScoreAndParGridElements: View {
  /// A list of holes to display in this view.
  let holes: [Hole]
  /// The total par from the given holes.
  var par: Int {
    return holes.reduce(0) { partialResult, hole in
      return partialResult + hole.holeData.par
    }
  }

  /// The total score from the given holes
  var score: Int {
    return holes.reduce(0) { partialResult, hole in
      return partialResult + hole.score
    }
  }

  var body: some View {
    // The grid row containing the par
    GridRow {
      ForEach(holes) { hole in
        Text("\(hole.holeData.par)")
      }

      Text("\(par)")

    }
    // grid view for score including the square and box desigfn based on score.
    GridRow {
      ForEach(holes) { hole in
        EmptyIfZeroText(value: hole.score)
          .padding(.horizontal, 5)
          .background {

            if hole.scoreToPar > 0 {
              CenteredSquare()
                .stroke(lineWidth: 1.2)
            } else if hole.scoreToPar < 0 && hole.score != 0 {
              Circle()
                .stroke(lineWidth: 1.2)
            }

          }

      }

      EmptyIfZeroText(value: score)

    }
    .padding(.top, 0.1)
  }
}

struct EmptyIfZeroText: View {
  let value: Int
  var body: some View {
    if value == 0 {
      Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
    } else {
      Text("\(value)")
    }
  }
}

extension Round {
  func colourFromScoreToPar() -> Color {
    if scoreToPar == 0 {
      return .blue
    }

    if scoreToPar > 0 {
      return .black
    }

    return .red
  }
}

extension Hole {
  /// Gets a colour from the score to par.
  ///
  /// - Returns: blue for a par, red for under par, black for over par.
  func getColourFromScore() -> Color {
    if score == 0 {
      return .blue
    }
    if score < 0 {
      return .red
    }

    return .black
  }

}

struct ScorecardImage_Previews: PreviewProvider {
  static var previews: some View {
    ScorecardImage(round: Round.completeRoundExample1)
  }

}

//MARK: Array extension
extension Array {

  /// Gets the last `k` elements in the array
  ///
  /// - Parameter k: The number of elements you would like to to grab from the end.
  /// - Returns: The last `k` elements from the array. If the array count is less than k it returns the entire array
  func getLast(_ k: Int) -> [Element] {
    if k >= self.count {
      // note the defensive copying here
      return self
    }
    let startIndex = self.count - 1 - k
    return self.enumerated().filter { $0.offset > startIndex }.map { $0.element }
  }
}
