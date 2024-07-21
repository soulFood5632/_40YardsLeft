//
//  LoadingAnimation.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-08-22.
//

import SwiftUI

struct LoadingAnimation: View {

  let timer = Timer.publish(every: 0.1, tolerance: 0.05, on: .main, in: .tracking)
    .autoconnect()
  @State private var sequence = 0

  var body: some View {
    HStack {
      Image(systemName: sequence == 0 ? "circle.fill" : "circle")
      Image(systemName: sequence == 1 ? "circle.fill" : "circle")
      Image(systemName: sequence == 2 ? "circle.fill" : "circle")
    }
    .onReceive(self.timer) { _ in
      sequence += 1
      if sequence >= 3 {
        sequence = 0
      }
    }
    .animation(.linear, value: self.sequence)

  }
}

struct LoadingAnimation_Previews: PreviewProvider {
  static var previews: some View {
    LoadingAnimation()
  }
}
