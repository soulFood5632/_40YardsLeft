//
//  SpinningCircle.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-05-01.
//

import SwiftUI

struct SpinningCircle: View {
    
    @State private var isSpinning = false
    let isLoading: Bool
    
    var body: some View {
        Image(systemName: "circle.dotted")
            .scaleEffect(isLoading ? 1 : 0)
            .rotationEffect(isSpinning ? .degrees(360): .zero)
            .animation(.easeInOut(duration: 3.2).repeatForever(autoreverses: true), value: self.isSpinning)
            .animation(.spring(dampingFraction: 0.8), value: self.isLoading)
            .onAppear {
                self.isSpinning = true
            }
            .onDisappear {
                self.isSpinning = false
            }
    }
}

struct SpinningCircle_Previews: PreviewProvider {
    static var previews: some View {
        SpinningCircle(isLoading: true)
    }
}
