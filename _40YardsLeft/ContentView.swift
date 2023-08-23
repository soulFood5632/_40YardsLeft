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
    
    @State private var userIsLoggedOut = false
    @State private var path = NavigationPath()
    
    

    var body: some View {
        NavigationStack(path: $path) {
            
            let _ = Self._printChanges()
            
            WelcomeScreen(path: $path)
                .navigationDestination(for: Golfer.self) { newGolfer in
                    
                    HomeView(golfer: newGolfer, path: self.$path)
                    
                }

        }
        .onChange(of: path) { newPath in
            print(newPath.count)
        }
        
    }
    
    

    
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
