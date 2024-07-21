//
//  BasicCourseInfo.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-01.
//

import SwiftUI

struct BasicCourseInfo: View {
  @Binding var buffer: CourseBuffer

  var body: some View {
    Grid(alignment: .leading) {

      GridRow {
        LabelAndField(prompt: "Name", text: self.$buffer.name)
      }

      GridRow {
        LabelAndField(prompt: "Address", text: self.$buffer.addressLine1)

      }

      GridRow {
        LabelAndField(prompt: "City", text: self.$buffer.city)

      }

      GridRow {
        PickerAndLabel(
          pickedElement: self.$buffer.country, choices: Country.allCases, title: "Country"
        )
      }

      GridRow {

        PickerAndLabel(
          pickedElement: self.$buffer.provice,
          choices: self.buffer.country.getPairedProvinces(), title: "Province/State")
      }

    }
    //TODO: manage the choices to ensure that the possible provinces match up with the expected.

  }
}

struct LabelAndField: View {
  let prompt: String
  @Binding var text: String

  var body: some View {
    Text(prompt + ":")
      .bold()
    TextField(prompt, text: self.$text)
      .textFieldStyle(.roundedBorder)
  }

}

struct BasicCourseInfo_Previews: PreviewProvider {
  @State private static var buffer = CourseBuffer()
  static var previews: some View {
    BasicCourseInfo(buffer: self.$buffer)
  }
}
