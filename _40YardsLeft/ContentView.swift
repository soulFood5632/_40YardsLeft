//
//  ContentView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-14.
//

import SwiftUI
import CoreData
import FirebaseAuth

struct ContentView: View {
    
    @State private var user: User?

    var body: some View {
        ZStack {
            
            UserView()
                .scaleEffect(user != nil ? CGSize(width: 1, height: 1) : .zero)
            
            WelcomeScreen(user: self.$user)
                .opacity(user == nil ? 1 : 0)
            
            
        }
        .onChange(of: user) { newUser in
            if newUser != nil {
                //TODO: call to database
            }
        }
        

    }

    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
