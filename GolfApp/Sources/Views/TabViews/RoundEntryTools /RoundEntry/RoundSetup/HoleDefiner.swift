//
//  HoleDefiner.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-01.
//

import SwiftUI

struct HoleDefiner: View {
  @Binding var holeDataList: [HoleData]
  @FocusState private var holeFocus: HoleFocus?
  var body: some View {
    Grid {
      ForEach(1...holeDataList.count) { holeNum in

        GridRow {

          SingleHoleText(holeData: self.$holeDataList[holeNum - 1], holeNumber: holeNum)
            .focused(self.$holeFocus, equals: HoleFocus.intToHole(holeNum))
            .onSubmit {
              if holeNum == holeDataList.count {
                holeFocus = nil
              }
              holeFocus = holeFocus?.getNext()
            }
            .submitLabel(holeNum != holeDataList.count ? .next : .done)
        }
      }
    }

  }
}

enum HoleFocus {
  case one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve,
    thirteen, fourteen, fifthteen, sixteen, seventeen, eighteen
}

extension HoleFocus {
  func getNext() -> HoleFocus? {
    switch self {
      case .one:
        return .two
      case .two:
        return .three
      case .three:
        return .four
      case .four:
        return .five
      case .five:
        return .six
      case .six:
        return .seven
      case .seven:
        return .eight
      case .eight:
        return .nine
      case .nine:
        return .ten
      case .ten:
        return .eleven
      case .eleven:
        return .twelve
      case .twelve:
        return .thirteen
      case .thirteen:
        return .fourteen
      case .fourteen:
        return .fifthteen
      case .fifthteen:
        return .sixteen
      case .sixteen:
        return .seventeen
      case .seventeen:
        return .eighteen
      case .eighteen:
        return nil
    }
  }

  static func intToHole(_ value: Int) -> HoleFocus {
    precondition(value >= 1 && value <= 18)
    switch value {
      case 1:
        return .one
      case 2:
        return .two
      case 3:
        return .three
      case 4:
        return .four
      case 5:
        return .five
      case 6:
        return .six
      case 7:
        return .seven
      case 8:
        return .eight
      case 9:
        return .nine
      case 10:
        return .ten
      case 11:
        return .eleven
      case 12:
        return .twelve
      case 13:
        return .thirteen
      case 14:
        return .fourteen
      case 15:
        return .fifthteen
      case 16:
        return .sixteen
      case 17:
        return .seventeen
      case 18:
        return .eighteen
      default:
        preconditionFailure("broke preconditions")
    }
  }
}

struct SingleHoleText: View {
  @Binding var holeData: HoleData
  let holeNumber: Int
  var body: some View {

    //TODO: add smart autofill for holedata so that par automatically updates with soft reference

    Text("\(holeNumber).")
      .bold()

    TextField("Yardage", value: self.$holeData.yardage.yards, formatter: .wholeNumber)
      .keyboardType(.numberPad)
      .onChange(
        of: self.holeData.yardage,
        perform: { yardage in
          self.holeData.par = ShotPredictor.getParFromYardage(distance: yardage)
        }
      )
      .onAppear {
        self.holeData.par = ShotPredictor.getParFromYardage(
          distance: self.holeData.yardage)
      }

    Picker("", selection: self.$holeData.par) {
      ForEach(possiblePars) { par in
        Text("\(par)")
      }
    }

    Picker("", selection: self.$holeData.handicap) {
      ForEach(possibleHandicaps) { handicap in
        Text("\(handicap)")
      }
    }

  }

}

extension SingleHoleText {
  private var possibleHandicaps: [Int] {
    var list = [Int]()
    for num in 1...18 {
      list.append(num)
    }

    return list
  }

  private var possiblePars: [Int] { [3, 4, 5] }
}

struct HoleDefiner_Previews: PreviewProvider {
  @State private static var holeData = [
    HoleData(yardage: .yards(400), handicap: 12, par: 10)
  ]
  static var previews: some View {
    HoleDefiner(holeDataList: self.$holeData)
  }
}

extension ShotPredictor {
  /// Gets a predicted par from the provided yardage.
  ///
  /// The values will correspond as follows
  ///  - < 250 yards -> 3
  ///  - \> 500 yards -> 5
  ///  - Otherwise -> 4
  ///
  ///
  /// - Parameter distance: The distance you would like to calculate the expected par of
  /// - Returns: The expected par value
  static func getParFromYardage(distance: Distance) -> Int {
    if distance.yards < 250 {
      return 3
    }
    if distance.yards > 500 {
      return 5
    }

    return 4
  }
}
