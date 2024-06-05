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
    @State private var isLoginReady = false
 
    
    var body: some View {
        
        VStack {
            
            
            
            let welcomeUserSize = animationMode.getSize(triggerValue: 1)
            
            let getStartedSize = animationMode.getSize(triggerValue: 1)
            
            let loginSize: CGSize = animationMode.getSize(triggerValue: 1)
            
            Group {
                Text("Welcome")
                    .foregroundColor(.white)
                    .font(.system(size: 75))
                    .bold()
                    .scaleEffect(welcomeUserSize)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                
                
                Group {
                    Text("Get Started")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    
                    Image(systemName: "arrow.down")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .onTapGesture {
                            self.isLoginReady = true
                        }
                    
                }
                .scaleEffect(getStartedSize)
                
                
                Group {
                    
                    if !self.loginForm && !self.newUserForm {
                        Button {
                            self.loginForm = true
                        } label: {
                            Label("Log In", systemImage: "person.crop.circle")
                        }
                        .font(.title2)
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 40)
                        
                        
                        Button {
                            self.newUserForm = true
                        } label: {
                            Label("Create Account", systemImage: "person.crop.circle.badge.plus")
                            
                        }
                        .font(.title2)
                        .buttonStyle(.borderedProminent)
                    } else if self.loginForm {
                        OldUserWelcome(user: self.$user,  showView: self.$loginForm)
                            
                    } else if self.newUserForm {
                        NewUserForm(showView: self.$newUserForm, user: self.$user)
                    }
                    
                    
                    //                    Button {
                    //                        Task {
                    //                            let tempUser = try await Authenticator.logIn(emailAddress: "loganu@shaw.ca", password: "Magenta^2")
                    //
                    //                            withAnimation(.easeInOut(duration: 1)) {
                    //                                self.user = tempUser
                    //                            }
                    //                        }
                    //
                    //                    } label: {
                    //                        Label("Admin", systemImage: "person.crop.circle.badge.plus")
                    //
                    //                    }
                    //                  .buttonStyle(.borderedProminent)
                }
                
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
//        .sheet(isPresented: self.$newUserForm, content: {
//            NewUserForm(user: self.$user)
//        })
//        .sheet(isPresented: self.$loginForm, content: {
//            OldUserWelcome(user: self.$user)
//        })
        .onReceive(self.signaller) { _ in
            
            withAnimation (.spring(dampingFraction: 0.7)) {
                self.animationMode.incrementAnimation()
            }

        }
        .animation(.easeInOut(duration: 1.5), value: self.loginForm)
        .animation(.easeInOut(duration: 1.5), value: self.newUserForm)
        .onAppear {
            if let id =  UserDefaults.standard.string(forKey: "RememberMe") {
                Task {
                    let golfer = try await DatabaseCommunicator.getGolfer(id: id)
                    
                    path.append(golfer)
                }
            }
        }
    }

}



struct WelcomeAnimation_Previews: PreviewProvider {
    @State static private var user = NavigationPath()
    static var previews: some View {
        ZStack {
            
            RadialBackground()
            
            WelcomeAnimation(path: self.$user)
                
            
            
        }
    }
}
