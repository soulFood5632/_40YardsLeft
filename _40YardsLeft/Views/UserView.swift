//
//  TabView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-24.
//

import SwiftUI
import FirebaseAuth

struct UserView: View {
    @Binding var golfer: Golfer
    

    var body: some View {
        NavigationStack {
            
            HomeView(golfer: $golfer)
        }

    }
}

enum LoginError: Error {
    case UserNotLoggedIn
}
