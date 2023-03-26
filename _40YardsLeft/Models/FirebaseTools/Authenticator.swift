//
//  Authenticator.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-23.
//

import Foundation
import FirebaseAuth

struct Authenticator {
    static func createUser(emailAddress: String, password: String) async throws -> User {
       
        
        let result = try await Auth.auth().createUser(withEmail: emailAddress, password: password)
        
        return result.user
        
        
        
        
    }
    
    static func logIn(emailAddress: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: emailAddress, password: password)

        return result.user
    }
        
    
}
