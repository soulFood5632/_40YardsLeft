//
//  RadialBackground.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-09-13.
//

import SwiftUI

struct RadialBackground: View {
    
    private static let END_RADIUS: CGFloat = 400
    private static let START_RADIUS: CGFloat = 100
    
    var body: some View {
        ZStack {
            RadialGradient(colors: [Color("softBlue"), Color("softGreen")], center: .center, startRadius: Self.START_RADIUS, endRadius: Self.END_RADIUS)
                .ignoresSafeArea()
            
            LinearGradient(colors: [.white, .clear], startPoint: .top, endPoint: .center)
                .ignoresSafeArea()
        }
        
        
        
    }
}

struct RadialBackground_Previews: PreviewProvider {
    static var previews: some View {
        RadialBackground()
    }
}
