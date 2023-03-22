//
//  TextValiditity.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-18.
//

import Foundation

/// A struct used to contain all the error checking mechanisms for
struct TextValiditity {
    
    static let passwordCheck: (String) -> [String] = { password in
        var errorList = [String]()
        
        if password.count <= 7 {
            errorList.append("Must be Longer than 7 Characters")
        } else {
            if password.contains(" ") {
                errorList.append("Must not Contain Spaces")
            }
            
            if !password.contains(try! Regex("[^A-Za-z0-9]+")) {
                errorList.append("Must Contain One Special Character")
            }
            
            if !password.contains(try! Regex("[A-Z]+")) {
                errorList.append("Must Contain One Capital Letter")
            }

            
            if !password.contains(try! Regex("[a-z]+")) {
                errorList.append("Must Contain One Lowercase Letter")
            }
            
            if !password.contains(try! Regex("[0-9]+")) {
                errorList.append("Must Contain One at Least 1 Number")
            }
        }
        
        return errorList

    }
}



