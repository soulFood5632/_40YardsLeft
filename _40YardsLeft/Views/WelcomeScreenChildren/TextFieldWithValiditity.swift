//
//  TextFieldWithValiditity.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-18.
//

import SwiftUI

struct TextFieldWithValiditity: View {
    let condition: (String) -> [String]
    
    @State private var currentValidity: [String] = []
    
    @Binding var text: String
    let prompt: String
    
    let isSecureField: Bool
    
    @Binding var isValid: Bool
    
    
    
    var body: some View {
        VStack {
            
            let textFieldColour = self.getColour()
            if isSecureField {
                SecureField(prompt, text: self.$text)
                    .autocorrectionDisabled()
                    .onChange(of: text) { newText in
                        withAnimation {
                            self.currentValidity = condition(newText)
                        }
                    }
                    .border(textFieldColour, width: 3)
                    .shadow(color: textFieldColour, radius: 3)
            } else {
                TextField(text: $text) {
                    Text(prompt)
                }
                .autocorrectionDisabled()
                .onChange(of: text) { newText in
                    withAnimation {
                        self.currentValidity = condition(newText)
                    }
                }
                .border(textFieldColour, width: 3)
                .shadow(color: textFieldColour, radius: 3)
        }
            
            if !currentValidity.isEmpty {
                VStack(alignment: .leading) {
                    ForEach(currentValidity, id: \.self) { error in
                        Label {
                            Text(error)
                                
                        } icon: {
                            Image(systemName: "xmark")
                        }
                        .font(.system(size: 11))
                        .foregroundColor(.red)
                        .multilineTextAlignment(.leading)
                    }
                }
                .background {
                    RoundedRectangle(cornerRadius: 2)
                        .foregroundColor(.white)
                }
            }
            
        }
        .onChange(of: currentValidity) { newErrors in
            if newErrors.isEmpty {
                self.isValid = true
            } else {
                self.isValid = false
            }
        }
            
    }
}


extension TextFieldWithValiditity {
    private func getColour() -> Color {
        withAnimation {
            if self.text.isEmpty {
                return .clear
            }
            
            if self.currentValidity.isEmpty {
                return .green
            }
            
            return .red
        }
    }
}


struct TextFieldWithValiditity_Previews: PreviewProvider {
    
    static var validity: (String) -> [String] =  { entry in
        var errors = [String]()
        if entry.count == 1 {
            errors.append("too long")
        }
        if entry.count == 1 {
            errors.append("too long")
        }
        
        return errors
    }
    
    static let prompt = "hello"
    @State static var binding = ""
    @State static var bool = false
    static var previews: some View {
        TextFieldWithValiditity(condition: validity, text: $binding, prompt: prompt, isSecureField: true, isValid: $bool)
            .border(.green)
            .padding()
            
    }
}
