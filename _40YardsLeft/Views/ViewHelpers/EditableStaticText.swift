//
//  EditableStaticText.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-17.
//

import SwiftUI

struct EditableStaticText: View {
    @Binding var text: String
    @Binding var isConfirmed: Bool
    @State private var isClicked = false
    @State private var isTextValid = false
    
    let originalText: String

    
    var body: some View {
        HStack {
            if isClicked {
                let mustNotBeEmptyAndEqual = TextValiditity.combine(conditions: [TextValiditity.betweenSizes(range: 1..<15), TextValiditity.mustNotBeEqualTo(originalText)])
                
                TextFieldWithValiditity(condition: mustNotBeEmptyAndEqual, text: $text, prompt: "", isSecureField: false, isValid: self.$isTextValid)
                    .padding(.trailing)
                    
                Spacer()
                
                Button("Confirm") {
                    self.isConfirmed = true
                    self.isClicked = false
                }
                .buttonStyle(.bordered)
                .disabled(!self.isTextValid)
                
            } else {
                Text(text)
                
                Spacer()
                
                Image(systemName: "pencil")
                    .onTapGesture {
                        withAnimation {
                            self.isClicked = true
                            self.isConfirmed = false
                        }
                    }
                    
            }
        }
    }
        
}

struct EditableStaticText_Previews: PreviewProvider {
    @State private static var text = "Lunderwood"
    @State private static var isConfirmed = false
    @State private static var isClicked = false
    static var previews: some View {
        EditableStaticText(text: self.$text, isConfirmed: self.$isConfirmed, originalText: self.text)
    }
}
