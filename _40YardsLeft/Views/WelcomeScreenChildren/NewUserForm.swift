//
//  NewUserForm.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-18.
//

import SwiftUI

struct NewUserForm: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    @Binding var actionComplete: Bool
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            Group {
                TextField("Username", text: self.$username)
                    
                TextFieldWithValiditity(condition: TextValiditity.passwordCheck, text: self.$password, prompt: "Password")
            }
            .textFieldStyle(.roundedBorder)
            
            
            Button {
                // create account API call
                self.actionComplete = false
            } label: {
                Text("Make Account")
                
                //TODO: change this to fit with the requirments.
                    .disabled(false)
            }
            .buttonStyle(.bordered)
            
        }
        //TODO: add alert
        .padding()
    }
}

struct NewUserForm_Previews: PreviewProvider {
    @State static private var username = false
  
    static var previews: some View {
        NewUserForm(actionComplete: self.$username)
    }
}
