////
////  LoginScreen.swift
////  _40YardsLeft
////
////  Created by Logan Underwood on 2023-04-14.
////
//
//import SwiftUI
//import FirebaseAuth
//
//struct LoginScreen: View {
//    @Binding var path: NavigationPath
//    @State private var user: User?
//    @State private var loginForm = false
//    @State private var newUserForm = false
//    
//    var body: some View {
//        
//
//        VStack {
//            
//            Group {
//                Button {
//                    self.loginForm = true
//                } label: {
//                    Label("Log In", systemImage: "person.crop.circle")
//                }
//                .buttonStyle(.borderedProminent)
//                .padding(.top, 40)
//                
//                
//                Button {
//                    self.newUserForm = true
//                } label: {
//                    Label("Create Account", systemImage: "person.crop.circle.badge.plus")
//                    
//                }
//                .buttonStyle(.borderedProminent)
//                
//                
//            }
//            .font(.title2)
//            
//        }
//        .padding(.horizontal)
//        .sheet(isPresented: self.$newUserForm, content: {
//            NewUserForm(user: self.$user)
//        })
//        .sheet(isPresented: self.$loginForm, content: {
//            OldUserWelcome(user: self.$user)
//        })
//        .onChange(of: self.user) { newUser in
//            if let newUser {
//                Task {
//                    try await DatabaseCommunicator.getGolfer(id: newUser.uid)
//                }
//            }
//        }
//        
//    }
//    
//}
//
//struct LoginScreen_Previews: PreviewProvider {
//    @State private static var user = NavigationPath()
//    static var previews: some View {
//        LoginScreen(path: $user)
//    }
//}
