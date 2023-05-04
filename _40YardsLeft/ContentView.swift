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
    
    

    var body: some View {
        ZStack {
            //TODO: allow the user to enter their details here 
            if let golfer = golfer {
                let golferBinding = Binding {
                    golfer
                } set: { newValue in
                    self.golfer = newValue
                }
                
                HomeView(golfer: golferBinding)

            }
            
            
            WelcomeScreen(user: self.$user)
                .opacity(user == nil ? 1 : 0)
            
        }
        .navigationDestination(isPresented: self.$userIsLoggedOut, destination: {
            LoginScreen(user: self.$user)
        })
        .onChange(of: Auth.auth().currentUser) { newUser in
            self.fetchGolferFromUser(newUser: newUser)
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
