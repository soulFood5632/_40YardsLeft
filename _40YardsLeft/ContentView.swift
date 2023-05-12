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
    @State private var golfer: Golfer?
    @State private var userIsLoggedOut = false
    @State private var path = NavigationPath()
    
    

    var body: some View {
        NavigationStack(path: $path) {
            
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

extension ContentView {
    func fetchGolferFromUser(newUser: User?) {
        if newUser != nil {
            self.user = newUser
            Task {
                do {
                    self.golfer = try await DatabaseCommunicator.getGolfer(id: newUser!.uid)
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            userIsLoggedOut = true
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
