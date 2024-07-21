//
//  _40YardsLeftApp.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-14.
//

import Firebase
import FirebaseCore
import SwiftUI

@main
struct _40YardsLeftApp: App {
  
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? =
    nil
  ) -> Bool {
    
    FirebaseApp.configure()
    
    let _ = Firestore.firestore()
    
    return true
  }
}

