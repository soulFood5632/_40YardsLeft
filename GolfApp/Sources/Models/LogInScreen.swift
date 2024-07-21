//
//  LogInScreen.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-14.
//

import SwiftUI

struct LogInScreen: View {
    
    
    
    @State private var userName = ""
    @State private var password = ""
    @State private var showSpinningCircle = false
    @State private var showNewAccount = false
     
    var body: some View {
        
        ZStack {
            
            
            VStack {
                
                Text("40 Yards Left")
                    .bold()
                    .font(.system(size: 45))
                    .padding()
                    .multilineTextAlignment(.center)
                
                PasswordEntry(username: self.$userName, password: self.$password)
                
                Button {
                    self.showSpinningCircle = true
                
                } label: {
                    Text("Login")
                }
                .buttonStyle(.bordered)
                .padding()
                
                
                Button {
                    self.showNewAccount = true
                } label: {
                    Text("Create a New Account")
                }
                .padding()
                

                
                
            }.background {
                RadialGradient(colors: [.green, .cyan],
                               center: .center, startRadius: 10, endRadius: 400)
                .shadow(radius: 3)
            }
            .padding()
            .sheet(isPresented: self.$showNewAccount) {
                NewAccountView()
            }
        }
        
      if self.showSpinningCircle {
        SpinningCircle(isLoading: true)
        }
        
    }
}

struct LogInScreen_Previews: PreviewProvider {
    static var previews: some View {
        LogInScreen()
    }
}
