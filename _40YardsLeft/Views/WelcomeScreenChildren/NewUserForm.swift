//
//  NewUserForm.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-18.
//

import SwiftUI
import FirebaseAuth

struct NewUserForm: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State var user: User?
    @State private var showAlert: Error? = nil
    
    var body: some View {
        VStack {
            Text("Add Account Details")
                .bold()
                .font(.title)
            
            Group {
                TextFieldWithValiditity(condition: TextValiditity.emailChecker, text: self.$email, prompt: "Email Address")
                    
                TextFieldWithValiditity(condition: TextValiditity.passwordCheck, text: self.$password, prompt: "Password")
            }
            .textFieldStyle(.roundedBorder)
            
            
            Button {
                
                Task {
                    do {
                        self.user = try await Authenticator.createUser(emailAddress: email, password: self.password)
                        
                    } catch {
                        // add error handlers
                        
                    }
                    
                }
                
            } label: {
                Text("Make Account")
                
                
            }
            .buttonStyle(.bordered)
            
           
            
        }
        .padding()
    }
}

struct NewUserForm_Previews: PreviewProvider {
    @State static private var user: User?
  
    static var previews: some View {
        NewUserForm()
    }
}
