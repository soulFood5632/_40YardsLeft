//
//  SwiftUIView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-18.
//

import SwiftUI

struct WelcomeAnimation: View {
    @Binding var showScreen: Bool
    
    @State private var animationMode = 0
    
    private var signaller = Timer.publish(every: 1.8, tolerance: 0.1, on: .main, in: .common)
    
    @State private var newAccountComplete = false
    
    
 
    
    var body: some View {
        ZStack {
            
            
            VStack {
                
                let welcomeUserSize = self.getSize(triggerValue: 1)
                
                let getStartedSize = self.getSize(triggerValue: 2)
                
                Text("Welcome User")
                    .foregroundColor(.white)
                    .font(.system(size: 55))
                    .bold()
                    .scaleEffect(welcomeUserSize)
                    .multilineTextAlignment(.center)
                
                Group {
                    Text("Get Started, Enter Account Details Below")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    
                    Image(systemName: "arrow.down")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        
                }
                .scaleEffect(self.getSize(triggerValue: 2))
                    
                
                NewUserForm(actionComplete: self.$newAccountComplete)
                    .scaleEffect(self.animationMode >= 3 ? 1 : 0)
                    
                    
                
                

                
            }
        }
        .onAppear {
            Task {
                try await Task.sleep(for: Duration(secondsComponent: 1, attosecondsComponent: 0))
                self.signaller.connect()
            }
        }
        .onReceive(self.signaller) { _ in
            withAnimation {
                if animationMode < 3 {
                    animationMode += 1
                }
                
            }
        }
    }

}

extension WelcomeAnimation {
    
    /// Gets the scaling size based on a trigger value.
    ///
    /// - When the animation mode is less than the trigger value then the size will be 0.
    /// - If the animation mode is equal the value will be sized by a factor of 1
    /// - else the value will be sized by a factor of 0.8
    ///
    /// - Parameter triggerValue: The value in which then animtion should be triggered at.
    /// - Returns: The size that the element should be scaled by depending on the animation mode and the given trigger value.
    private func getSize(triggerValue: Int) -> CGSize {
        if self.animationMode < triggerValue {
            return .zero
        }
        
        if self.animationMode == triggerValue {
            return CGSize(width: 1, height: 1)
        }
        
        return CGSize(width: 0.8, height: 0.8)
    }
}





struct WelcomeAnimation_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeAnimation()
    }
}
