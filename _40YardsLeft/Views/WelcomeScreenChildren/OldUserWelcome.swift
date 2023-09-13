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
    @State private var rememberMe = UserDefaults.standard.string(forKey: "RememberMe") != nil
    @Binding var showView: Bool

    @State private var showAlert: (Bool, String?) = (false, nil)
    
    var body: some View {
        GroupBox {
            
            Image(systemName: "person.crop.circle")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 50)
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
            
            Toggle(isOn: self.$rememberMe) {
                Text("Remember Me")
            }
            .font(.caption)
            .toggleStyle(.switch)
            
            Button {
                Task {
                    do {
                        
                        let tempUser = try await Authenticator.logIn(emailAddress: emailAddress, password: self.password)
                        
                        if self.rememberMe {
                            UserDefaults.standard.set(tempUser.uid, forKey: "RememberMe")
                        } else {
                            UserDefaults.standard.removeObject(forKey: "RememberMe")
                        }
                        
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
            HStack {
                Label("Welcome Back", systemImage: "hand.wave.fill")
                Spacer()
                Button(role: .destructive) {
                    self.showView = false
                } label: {
                    Image(systemName: "x.circle")
                }
            }
        }
        .alert("Login Error", isPresented: self.$showAlert.0, actions: {
            Button {
                withAnimation {
                    self.resetFields()
                }
                
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
    @State private static var showView = true
    static var previews: some View {
        OldUserWelcome(user: $user, showView: self.$showView)
    }
}
