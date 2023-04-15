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
        
        VStack {
            GroupBox {
                AccountDetails()
            } label: {
                Label("Account Settings", systemImage: "key")
                //Not sure
            }
        }
        .padding()
        .toolbar {
            ToolbarItem (placement: .destructiveAction) {
                Button("Log Out", role: .destructive) {
                    do {
                        try Auth.auth().signOut()
                    } catch {
                        //TODO: finish this error checking mechanism
                        print(error.localizedDescription)
                    }
                }
                .foregroundColor(.red)
            }
        }
    }
        
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
        }
    }
}
