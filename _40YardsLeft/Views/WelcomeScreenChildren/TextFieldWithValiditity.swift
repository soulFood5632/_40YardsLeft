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
    
    @State var isValid: Bool = false
    
    
    
    var body: some View {
        VStack {
            
            let textFieldColour = self.getColour()
            
            TextField(text: $text) {
                Text(prompt)
            }
            .onChange(of: text) { newText in
                withAnimation {
                    self.currentValidity = condition(newText)
                }
                if self.currentValidity.isEmpty {
                    self.isValid = true
                } else {
                    self.isValid = false
                }
            }
            .border(textFieldColour, width: 3)
            .shadow(color: textFieldColour, radius: 3)
            
            if !currentValidity.isEmpty {
                VStack(alignment: .leading) {
                    ForEach(currentValidity, id: \.self) { error in
                        Label {
                            Text(error)
                                
                        } icon: {
                            Image(systemName: "xmark")
                        }
                        .font(.system(size: 9.8))
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
    static var previews: some View {
        TextFieldWithValiditity(condition: validity, text: $binding, prompt: prompt)
            .border(.green)
            .padding()
            
    }
}
