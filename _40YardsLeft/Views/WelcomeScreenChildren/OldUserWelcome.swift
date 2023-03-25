//
//  OldUserWelcome.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-19.
//

import SwiftUI
import Firebase

struct OldUserWelcome: View {
    @Binding var user: User?
    @State private var emailAddress = ""
    @State private var password = ""
    @FocusState private var focuser: FocusedFeild?

    @State private var showAlert = false
    @State private var errorText: String?
    var body: some View {
        GroupBox {
            
            Image(systemName: "person.crop.circle")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 140)
                .padding()
            
            
            Group {
                TextField("Email Address", text: self.$emailAddress)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .submitLabel(.next)
                    .focused(self.$focuser, equals: .email)
                    .onSubmit {
                        self.focuser = .password1
                    }
                    
                SecureField("Password", text: self.$password)
                    .textContentType(.password)
                    .focused(self.$focuser, equals: .password1)
                    
            }
            .textFieldStyle(.roundedBorder)
            
            Button {
                Task {
                    do {
                        self.user = try await Authenticator.logIn(emailAddress: emailAddress, password: self.password)
                        
                    } catch {
                        //add error handlers
                    }
                        
                    
                }
            } label: {
                Text("Login")
            }
            .buttonStyle(.bordered)
            
            
            
            
        } label: {
            Label("Welcome Back", systemImage: "hand.wave.fill")
        }
        
        .padding()
        
        
    }
}

struct OldUserWelcome_Previews: PreviewProvider {
    @State static private var user: User?
    static var previews: some View {
        OldUserWelcome(user: $user)
    }
}
