//
//  PasswordEnrty.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-14.
//

import SwiftUI

struct PasswordEntry: View {
    @Binding var username: String
    @Binding var password: String
    
    var body: some View {
        TextField(text: self.$username) {
            Text("Username")
                .padding()
        }
        .textFieldStyle(.roundedBorder)
        .padding()
        
        TextField(text: self.$password) {
            Text("Password")
                .padding()
        }
        .textFieldStyle(.roundedBorder)
        .padding()
    }
}

struct PasswordEntry_Previews: PreviewProvider {
    @State static var username = ""
    @State static var password = ""
    static var previews: some View {
        PasswordEntry(username: $username, password: $password)
    }
}
