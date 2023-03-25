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
    @State private var currentView: ViewScreens = .home

    var body: some View {
        
        WelcomeScreen(user: self.$user)
            .opacity(user == nil ? 1 : 0)
            .animation(.easeInOut, value: user)
        
        
        
            
                
        
        

    }

    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
