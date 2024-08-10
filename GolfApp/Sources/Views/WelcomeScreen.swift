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

  private static let END_RADIUS: CGFloat = 400
  private static let START_RADIUS: CGFloat = 100

  var body: some View {

    
      WelcomeAnimation(path: self.$path)

    

  }
}
