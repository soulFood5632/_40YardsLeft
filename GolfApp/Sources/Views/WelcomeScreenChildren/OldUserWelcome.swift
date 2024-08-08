////
////  OldUserWelcome.swift
////  _40YardsLeft
////
////  Created by Logan Underwood on 2023-03-19.
////
//
//import FirebaseAuth
//import SwiftUI
//
//
//
//struct OldUserWelcome: View {
//  @Binding var user: User?
//  @State private var emailAddress = ""
//  @State private var password = ""
//  @State private var isPasswordHidden = true
//  @State private var rememberMe =
//    UserDefaults.standard.string(forKey: "RememberMe") != nil
//
//  @State private var showAlert: (Bool, String?) = (false, nil)
//  
//  
//
//  var body: some View {
//
//    VStack {
//      
//      
//
//      Spacer()
//      
//
//      
//      
//      
//
//      
//    }
//    
//
//  }
//}
//
//
//
//extension OldUserWelcome {
//  private func resetFields() {
//    self.password = ""
//    self.emailAddress = ""
//  }
//}
//
//struct OldUserWelcome_Previews: View {
//  @State private var user: User?
//  @State private var showView = true
//  var body: some View {
//    NavigationStack {
//      
//      OldUserWelcome(user: $user)
//        .padding()
//    }
//    
//  }
//}
//
//#Preview {
//  OldUserWelcome_Previews()
//  
//}
