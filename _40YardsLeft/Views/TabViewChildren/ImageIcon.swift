//
//  ImageIcon.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-24.
//

import SwiftUI

struct ImageIcon: View {
    let systemName: String
    let iconValue: ViewScreens
    @Binding var currentScreen: ViewScreens
    
    private var isActive: Bool { iconValue == currentScreen }
    
    var body: some View {
        Image(systemName: systemName)
            .bold(isActive)
            .onTapGesture {
                currentScreen = iconValue
            }
            .background {
                if isActive {
                    RoundedRectangle(cornerRadius: 2)
                        .foregroundColor(.secondary)
                        .opacity(0.5)
                }
            }
    }
}

struct ImageIcon_Previews: PreviewProvider {
    @State private static var currentScreen: ViewScreens = .home
    
    static var previews: some View {
        ImageIcon(systemName: "figure.golf", iconValue: .roundEntry, currentScreen: self.$currentScreen)
    }
}
