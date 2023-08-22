//
//  Authenticator.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-23.
//

import Foundation
import FirebaseAuth


/// An authenticator object which can be used to validate users and create new ones as needed. 
struct Authenticator {
    
    /// Asynchronisly creates a new `user` and returns the new `user`.
    ///
    /// - Parameters:
    ///   - emailAddress: The email address of the new user.
    ///   - password: The password of the new user
    /// - Returns: The newly created `User`
    static func createUser(emailAddress: String, password: String) async throws -> User {
        let result = try await Auth.auth().createUser(withEmail: emailAddress, password: password)
        
        return result.user
    }
    
    
    /// Attempts to login using the provided credentials
    ///
    /// - Throws: `FirebaseAuth` erros based on different type of failure to log in.
    ///
    /// - Parameters:
    ///   - emailAddress: The email address for the account
    ///   - password: The paired password with the provided email address
    /// - Returns: The user which has been logged into
    static func logIn(emailAddress: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: emailAddress, password: password)

        return result.user
    }
        
    
}
