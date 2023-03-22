//
//  Welcome Screen.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-18.
//

import Foundation
import SwiftUI

struct WelcomeScreen : View {
    
    @State private var endRadiusChange: CGFloat = Self.START_RADIUS * 2
    
    private static let END_RADIUS: CGFloat = 400
    
    private static let START_RADIUS: CGFloat = 67
    
    @State private var screenReady = false
    
 
    var body: some View {
        
        ZStack {
            RadialGradient(colors: [.blue, .cyan, .green, .mint], center: .center, startRadius: Self.START_RADIUS, endRadius: self.endRadiusChange)
                .ignoresSafeArea()
            
            if screenReady {
                WelcomeAnimation()
            }
            
        }
        .onAppear {
            withAnimation (.easeInOut(duration: 2)) {
                endRadiusChange = Self.END_RADIUS
            }
            Task {
                //call core data to see if a user has been entered.
                self.screenReady = true
            }
        }
        
    }
}
