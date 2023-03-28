//
//  SettingsView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-26.
//

import SwiftUI
import FirebaseAuth

struct newSettings {
    var gender: Gender
    var name: String
    var email: String
}

struct SettingsView: View {
    var body: some View {
        if let user = Auth.auth().currentUser {
            
        }
    }
        
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
