//
//  HotOrColdView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-13.
//

import SwiftUI

/// A view which shows a fire or ice icon based on the provided isHot value
struct HotOrColdView: View {
  let isHot: ThreeState

  var body: some View {
    switch isHot {
      case .hot:
        Image(systemName: "flame")
          .foregroundColor(.red)
      case .mild:
        EmptyView()
      case .cold:
        Image(systemName: "thermometer.snowflake")
          .foregroundColor(.blue)
    }

  }
}

struct HotOrColdView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      HotOrColdView(isHot: .hot)
      HotOrColdView(isHot: .mild)
      HotOrColdView(isHot: .cold)
    }
  }
}
