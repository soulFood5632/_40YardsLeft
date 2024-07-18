//
//  GoHome.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-05-10.
//

import SwiftUI

/// A view which houses a button which deletes all but one element on the stack
struct GoHome: View {
  @Binding var path: NavigationPath
  var body: some View {

    Button {
      path.keepFirst()
    } label: {
      Image(systemName: "house")
    }

  }
}
