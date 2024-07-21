//
//  PickerAndLabel.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-05-01.
//

import SwiftUI

/// A generic picker and label struct to be used in the case of grids.
///
/// - Important: The picker will need to be encased in a grid when used.
struct PickerAndLabel<T: Hashable>: View where T: Identifiable, T: StringRepresentable {
  @Binding var pickedElement: T
  let choices: [T]
  let title: String

  var body: some View {

    Text(title + ":")
      .bold()

    Picker(selection: $pickedElement) {
      ForEach(choices) { country in
        Text(country.toString())
      }
    } label: {
      // empty label
    }

  }
}

struct PickerAndLabel_Previews: PreviewProvider {
  @State private static var country = Country.Canada

  static var previews: some View {
    Grid {
      PickerAndLabel(
        pickedElement: self.$country, choices: Country.allCases, title: "Country")

    }
  }
}
