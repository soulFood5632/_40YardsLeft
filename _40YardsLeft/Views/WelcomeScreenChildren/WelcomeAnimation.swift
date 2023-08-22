//
//  SwiftUIView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-18.
//

import SwiftUI
import FirebaseAuth

struct WelcomeAnimation: View {
    
    @State private var animationMode = SizeAnimation()
    
    private let signaller = Timer.publish(every: 1.8, tolerance: 0.1, on: .main, in: .common).autoconnect()
    
    
    @State private var newUserForm = false
    @State private var loginForm = false
    
    @State private var user: User?
    @Binding var path: NavigationPath
 
    
    var body: some View {
        
        VStack {
            
            let welcomeUserSize = animationMode.getSize(triggerValue: 1)
            
            let getStartedSize = animationMode.getSize(triggerValue: 1)
            
            let loginSize: CGSize = animationMode.getSize(triggerValue: 1)
            
            Group {
                Text("Welcome User")
                    .foregroundColor(.white)
                    .font(.system(size: 55))
                    .bold()
                    .scaleEffect(welcomeUserSize)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                
                
                Group {
                    Text("Get Started Below")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    
                    Image(systemName: "arrow.down")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                    
                }
                .scaleEffect(getStartedSize)
                
                
                Group {
                    Button {
                        self.loginForm = true
                    } label: {
                        Label("Log In", systemImage: "person.crop.circle")
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 40)
                    
                    
                    Button {
                        self.newUserForm = true
                    } label: {
                        Label("Create Account", systemImage: "person.crop.circle.badge.plus")
                        
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button {
                        Task {
                            let tempUser = try await Authenticator.logIn(emailAddress: "loganu@shaw.ca", password: "Magenta^2")
                            
                
                            
                        
                            
                            withAnimation(.easeInOut(duration: 1)) {
                                self.user = tempUser
                            }
                        }
                        
                    } label: {
                        Label("Admin", systemImage: "person.crop.circle.badge.plus")
                        
                    }
                    .buttonStyle(.borderedProminent)
                    
                    
                    
                    
                }
                .font(.title2)
                .scaleEffect(loginSize)
            }
            .padding(.horizontal)
            
            
            
        }
        .onChange(of: user) { newUser in
            if let newUser {
                self.newUserForm = false
                self.loginForm = false
                
                Task {
                    
                    let golfer = try await DatabaseCommunicator.getGolfer(id: newUser.uid)
                    
                    path.append(golfer)
                }
            }
        }
        .sheet(isPresented: self.$newUserForm, content: {
            NewUserForm(user: self.$user)
        })
        .sheet(isPresented: self.$loginForm, content: {
            OldUserWelcome(user: self.$user)
        })
        .onReceive(self.signaller) { _ in
            
            withAnimation (.spring(dampingFraction: 0.7)) {
                self.animationMode.incrementAnimation()
            }

        }
    }

}



struct WelcomeAnimation_Previews: PreviewProvider {
    @State static private var user = NavigationPath()
    static var previews: some View {
        WelcomeAnimation(path: self.$user)
            .background(.black)
    }
}
