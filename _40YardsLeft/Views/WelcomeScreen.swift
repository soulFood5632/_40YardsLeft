//
//  Welcome Screen.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-18.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct WelcomeScreen : View {
    
    @Binding var path: NavigationPath
    
    private static let END_RADIUS: CGFloat = 400
    private static let START_RADIUS: CGFloat = 100
    
    @State private var endRadius = Self.START_RADIUS * 2
    
 
    var body: some View {
        
        ZStack {
            RadialGradient(colors: [.blue, .green], center: .center, startRadius: Self.START_RADIUS, endRadius: self.endRadius)
                .ignoresSafeArea()
                .opacity(0.4)
            
            WelcomeAnimation(path: self.$path)
            
        }
        .onAppear {
            withAnimation (.spring(dampingFraction: 0.6)) {
                endRadius = Self.END_RADIUS
            }
            
        }
        
    }
}
