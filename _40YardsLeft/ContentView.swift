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
    
    

    var body: some View {
        ZStack {
            
            if let golfer = golfer {
                let golferBinding = Binding {
                    golfer
                } set: { newValue in
                    
                    //TODO: add post to database during change
                    self.golfer = newValue
                }
                
                UserView(golfer: golferBinding)

            }
            
            
            WelcomeScreen(user: self.$user)
                .opacity(user == nil ? 1 : 0)
            
        }
        .onChange(of: Auth.auth().currentUser) { newUser in
            self.user = newUser
            Task {
                do {
                    self.golfer = try await DatabaseCommunicator.getGolfer(id: newUser!.uid)
                } catch {
                    //TODO: add error checking here
                }
            }
        }

    }
    
    

    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
