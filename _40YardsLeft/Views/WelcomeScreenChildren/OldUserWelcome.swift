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

    @State private var showAlert: (Bool, String?) = (false, nil)
    
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
                        
                        let tempUser = try await Authenticator.logIn(emailAddress: emailAddress, password: self.password)
                        
                        withAnimation(.easeInOut(duration: 1)) {
                            self.user = tempUser
                            
                        }
                        
                        
                    } catch {
                        self.showAlert.1 = error.localizedDescription
                        self.showAlert.0 = true
                    }
                        
                    
                }
            } label: {
                Text("Login")
            }
            .buttonStyle(.bordered)
            
            
            
            
        } label: {
            Label("Welcome Back", systemImage: "hand.wave.fill")
        }
        .alert("Login Error", isPresented: self.$showAlert.0, actions: {
            Button {
                self.resetFields()
                
            } label: {
                Text("Retry")
            }
        }, message: {
            Text(self.showAlert.1 ?? "Unknown Error")
        })
        
        .padding()
        
        
    }
}

extension OldUserWelcome {
    private func resetFields() {
        self.password = ""
        self.emailAddress = ""
    }
}

struct OldUserWelcome_Previews: PreviewProvider {
    @State static private var user: User?
    static var previews: some View {
        OldUserWelcome(user: $user)
    }
}
