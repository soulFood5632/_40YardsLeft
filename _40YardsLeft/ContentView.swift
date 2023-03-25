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
        
        WelcomeScreen(user: self.$user)
            .opacity(user == nil ? 1 : 0)
        
        TabView()
            .scaleEffect(user != nil ? .zero : CGSize(width: 1, height: 1))
        

    }

    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
