//
//  AccountDetails.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-14.
//

import SwiftUI
import FirebaseAuth

struct AccountDetails: View {
    @State private var email = ""
    @State private var firstPassword = ""
    @State private var passwordCheck = ""
    
    @State private var validityCheck = [false, false, false]
    var body: some View {
        VStack {
            
            
            TextFieldWithValiditity(condition: TextValiditity.emailChecker,
                                    text: self.$email,
                                    prompt: "New Email",
                                    isSecureField: false,
                                    isValid: self.$validityCheck[0]).textContentType(.emailAddress)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
            
            
            Button("Change Email") {
                Task {
                    // should not be nil, but lets say it is
                    if let account = Auth.auth().currentUser {
                        account.updateEmail(to: self.email)
                    } else {
                        print("You have been logged out what the hell is happening")
                    }
                }
            }
            .disabled(!validityCheck[0])
            .buttonStyle(.bordered)
            
            Divider()
            
            TextFieldWithValiditity(condition: TextValiditity.passwordCheck, text: self.$firstPassword, prompt: "Password", isSecureField: true, isValid: self.$validityCheck[1])
                .textContentType(.newPassword)
                .textFieldStyle(.roundedBorder)
                
                
            
            let condition: (String) -> [String] = { entry in
                if entry != self.firstPassword {
                    return ["Passwords Do Not Match"]
                }
                return []
            }
            
            TextFieldWithValiditity(condition: condition, text: self.$passwordCheck, prompt: "Re-Enter Password", isSecureField: true, isValid: self.$validityCheck[2])
                .textContentType(.newPassword)
                .textFieldStyle(.roundedBorder)
            
            
            Button("Reset Password") {
                Task {
                    if let user = Auth.auth().currentUser {
                        try await user.updatePassword(to: self.firstPassword)
                    } else {
                        print("user has been logged out somehow")
                    }
                }
            }
            .disabled(!self.validityCheck[1] || !self.validityCheck[2])
            .buttonStyle(.bordered)
                
            
        }
    }
}

struct AccountDetails_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetails()
    }
}
