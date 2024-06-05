//
//  SquareButton.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-11-08.
//

import SwiftUI

struct SquareButton: View {
    let binding: () -> Void
    let text: String
    let icon: String

    
    var body: some View {
        Label(text, systemImage: icon)
            .font(.system(size: 50))
            .bold()
            .padding()
            .background {
                Rectangle()
                    .foregroundColor(.secondary)
            }
            
            
    }
}

struct SquareButton_Previews: PreviewProvider {
    static var previews: some View {
        SquareButton(binding: { }, text: "hello", icon: "plus")
    }
}
