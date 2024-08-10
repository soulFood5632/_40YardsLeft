//
//  Welcome Screen.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-18.
//


import Foundation
import SwiftUI

struct WelcomeScreen: View {

  @Binding var path: NavigationPath



  var body: some View {

    
      WelcomeAnimation(path: self.$path)

    

  }
}

#Preview {
  @State var path = NavigationPath()
  return WelcomeScreen(path: $path)
}
