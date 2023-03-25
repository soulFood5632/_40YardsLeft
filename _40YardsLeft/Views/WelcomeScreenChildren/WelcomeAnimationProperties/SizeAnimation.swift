//
//  SizeAnimation.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-23.
//

import Foundation

struct SizeAnimation {
    private(set) var mode = 0
    
    
    /// Increments the counter which handles the sequence of animations.
    public mutating func incrementAnimation() {
        if self.mode < 3 {
            self.mode += 1
        }
    }
    
    /// Gets the scaling size based on a trigger value.
    ///
    /// - When the animation mode is less than the trigger value then the size will be 0.
    /// - If the animation mode is equal the value will be sized by a factor of 1
    ///
    /// - Parameter triggerValue: The value in which then animtion should be triggered at.
    /// - Returns: The size that the element should be scaled by depending on the animation mode and the given trigger value.
    public func getSize(triggerValue: Int) -> CGSize {
        if self.mode < triggerValue {
            return .zero
        }
        
        return CGSize(width: 1, height: 1)
        
        

        
        
    }
}









