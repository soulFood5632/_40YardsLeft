//
//  OldUserWelcome.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-19.
//

import SwiftUI

struct OldUserWelcome: View {
    @State public var actionComplete = false
    @State private var username = ""
    @State private var password = ""
    
    @State private var newUserForm = false
    
    @State private var newUserCreated = false
    
    var body: some View {
        VStack {
            Text("Please Login Below")
                .foregroundColor(.white)
                .font(.system(size: 55))
                .bold()
                .multilineTextAlignment(.center)
            
            TextField("Username", text: self.$username)
            TextField("Password", text: self.$password)
            
            Button {
                Task {
                    //api call to check
                }
            } label: {
                Text("Login")
            }
            .buttonStyle(.bordered)
            
            Button {
                self.newUserForm = true
            } label: {
                Text("Create New Account")
            }
        }
        .sheet(isPresented: self.$newUserForm) {
            NewUserForm(actionComplete: self.$newUserCreated)
        }
        onChange(of: self.newUserCreated) { isSuccess in
            if isSuccess {
                
            }
        }
        
    }
}

struct OldUserWelcome_Previews: PreviewProvider {
    @State private var showScreen = true
    static var previews: some View {
        OldUserWelcome()
    }
}
