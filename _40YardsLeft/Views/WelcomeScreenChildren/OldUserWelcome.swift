//
//  OldUserWelcome.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-19.
//

import SwiftUI
import Firebase

struct OldUserWelcome: View {
    @State var user: User?
    @State private var emailAddress = ""
    @State private var password = ""

    var body: some View {
        VStack {
            
            Text("Login Below")
                .bold()
                .font(.title)
            
            Group {
                TextField("Email Address", text: self.$emailAddress)
                    
                TextField("Password", text: self.$password)
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
            
            
            
            
        }
        .padding()
        
        
    }
}

struct OldUserWelcome_Previews: PreviewProvider {
    @State private var showScreen = true
    static var previews: some View {
        OldUserWelcome()
    }
}
