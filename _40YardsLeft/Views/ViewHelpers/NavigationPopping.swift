//
//  NavigationPopping.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-05-10.
//

import Foundation
import SwiftUI

extension NavigationPath {
    
    /// Keeps the first `x` entries in the list of values.
    ///
    /// - Requires: the `number` of kept entries is greater than or equal to 0.
    ///
    /// - Parameter number: The number of entries you would like to keep.
    mutating func keepFirst(_ number: Int) {
        precondition(number >= 0)
        // if the number of entries to keep is greater than the number of entries in the stack then early return.
        if self.count < number {
            return
        }
        
        let entriesToDelete = self.count - number
            
        self.removeLast(entriesToDelete)
    }
    
    mutating func keepFirst() {
        self.keepFirst(1)
    }

}
