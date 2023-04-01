//
//  _40YardsLeftApp.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-14.
//

import SwiftUI

import Firebase

@main
struct _40YardsLeftApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()

                
        }
    }
}

class AppDelegate : NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
        
        return true
    }
}
