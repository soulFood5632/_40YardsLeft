//
//  SettingsView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-26.
//

import FirebaseAuth
import SwiftUI

struct newSettings {
  var gender: Gender
  var name: String
  var email: String
}

struct SettingsView: View {
  @Binding var golfer: Golfer
  @Binding var path: NavigationPath

  var body: some View {

    VStack {
      GroupBox {
        AccountDetails()
      } label: {
        Label("Account Settings", systemImage: "key")
        //Not sure
      }

      Divider()

      GroupBox {
        ProfileDetails(golfer: $golfer, profileBuffer: .init(golfer: golfer))
      } label: {
        Label("Profile Settings", systemImage: "person")
      }

    }
    .navigationTitle("Settings")
    .padding()
    .toolbar {
      ToolbarItem(placement: .destructiveAction) {
        Button("Log Out", role: .destructive) {
          do {
            try Auth.auth().signOut()
            path.keepFirst(0)
            
            
          } catch {
            
            print(error.localizedDescription)
          }
        }
        .foregroundColor(.red)
      }
    }
  }

}


