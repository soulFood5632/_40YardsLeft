//
//  SpinningCircle.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-14.
//

import SwiftUI

struct SpinningCircle: View {
    
    @State private var spin = false
    
    var body: some View {
        Image(systemName: "arrow.2.circlepath.circle.fill")
            .resizable()
            .frame(width: 128, height: 128)
            .rotationEffect(Angle(degrees: spin ? 360 : 0))
            .animation(Animation.linear(duration: 0.8).repeatForever(autoreverses: false), value: spin)
            .padding()
            .onAppear() {
                spin.toggle()
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.secondary)
                    .opacity(0.3)
            }
    }
}


struct SpinningCircle_Previews: PreviewProvider {
    static var previews: some View {
        SpinningCircle()
    }
}
