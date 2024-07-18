//
//  RoundFilter.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-08-21.
//

import SwiftUI

struct RoundFilterView: View {
  @Binding var startDate: Date
  @Binding var endDate: Date
  @Binding var roundType: [RoundType]
  @Binding var ratingBound: Range<Double>

  var body: some View {
    VStack(alignment: .leading) {
      GroupBox {
        HStack {
          DatePicker(selection: $startDate) {
            Text("Start:")
              .bold()
          }
        }

        HStack {
          DatePicker(selection: $endDate) {
            Text("End:")
              .bold()
          }
        }

        HStack {
          ForEach(RoundType.allCases.sorted { $0.rawValue < $1.rawValue }) { type in

            Label(
              type.rawValue,
              systemImage: roundType.contains(type) ? "checkmark.circle" : "circle"
            )
            .bold(roundType.contains(type))
            .font(.system(size: 15))
            .onTapGesture {
              if roundType.contains(type) {
                roundType.removeAll { $0 == type }
              } else {
                roundType.append(type)
              }
            }
            .padding(.top, 3)

          }
        }

      }
    }
  }
}

struct RoundFilterView_Previews: PreviewProvider {

  @State static private var startDate: Date = .now.jumpDaysAhead(by: -150)
  @State static private var endDate: Date = .now

  @State static private var roundType: [RoundType] = RoundType.allCases

  @State static private var ratingBound: Range<Double> = 67.0..<75.0
  static var previews: some View {
    RoundFilterView(
      startDate: self.$startDate, endDate: self.$endDate, roundType: self.$roundType,
      ratingBound: $ratingBound)
  }
}
