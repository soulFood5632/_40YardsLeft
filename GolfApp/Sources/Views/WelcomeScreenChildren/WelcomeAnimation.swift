//
//  SwiftUIView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-18.
//


import SwiftUI
import FirebaseAuth

struct LoginInfo: Equatable {
  var emailAddress: String
  var password: String
  
  init(emailAddress: String, password: String) {
    self.emailAddress = emailAddress
    self.password = password
  }
  
  init() {
    self.emailAddress = ""
    self.password = ""
  }
  
  var isValid: Bool { self.emailAddress != "" && self.password != "" } // TODO: implement an actual checking method here.
  
  mutating func reset(email: Bool) -> Void {
    if email {
      self.emailAddress = ""
    }
    self.password = ""
  }
}

struct WelcomeAnimation: View {

  
  @State private var creatingNewUser = false
  @State private var spinLoginButton = false
  
  @State private var loginInfo = LoginInfo()
  @State private var rememberMe = false
  
  @State private var alert: (Bool, String?) = (false, nil)
  
  @State private var user: User?
  @Binding var path: NavigationPath
  

  var body: some View {
    ZStack {
    
      
      VStack {
        
        
        LoginDetails(emailAddress: self.$loginInfo.emailAddress, password: self.$loginInfo.password)
        
        
        Toggle("Remember Me", isOn: self.$rememberMe)
          .toggleStyle(iOSCheckboxToggleStyle())
          .labelsHidden()
          .padding(.vertical, 5)
          .padding(.horizontal)
        
        Button {
          self.spinLoginButton = true
          Task {
            do {
              
              self.user = try await login(loginInfo: self.loginInfo, rememberMe: self.rememberMe)
            } catch {
              self.spinLoginButton = false
              self.alert.0 = true
              self.alert.1 = error.localizedDescription
            }
          }
        } label: {
          Group {
            if self.spinLoginButton {
              SpinningCircle(isLoading: self.spinLoginButton)
              
            } else {
              Text("Login")
                .opacity(self.loginInfo.isValid ? 1 : 0.6)
            }
          }
          .font(.title2)
          .bold()
          .foregroundStyle(.white)
              
            
          
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background {
          LinearGradient(colors: [self.loginInfo.isValid ? .green : .gray, self.loginInfo.isValid ? .blue: .gray], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        .clipShape(.rect(cornerRadius: 20))
        
        
        
        Button {
          self.creatingNewUser = true
        } label: {
          Text("Create Account")
            .font(.title3)
            .bold()
        }
        .disabled(self.spinLoginButton)
        
        
        
      }
    }
    .padding()
    .sheet(isPresented: self.$creatingNewUser, content: {
      NewUserFormUpdate(showView: self.$creatingNewUser, user: self.$user)
        .padding()
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Label("Cancel", systemImage: "trash")

          }
        }
    })
    .animation(.easeInOut, value: self.loginInfo)
    .animation(.easeInOut(duration: 0.2), value: self.spinLoginButton)
    .animation(.easeInOut, value: self.user)
    .alert("Login Error", isPresented: self.$alert.0, actions: {
      Button {
        self.loginInfo.reset(email: false)
      } label: {
        Text("Retry")
      }
    }, message: {
      if let alertDesc = self.alert.1 {
        Text(alertDesc)
      } else {
        EmptyView()
      }
    })
    .onChange(of: user) { newUser in
      if let newUser {

        Task {
          let golfer = try await DatabaseCommunicator.getGolfer(id: newUser.uid)

          path.append(golfer)
        }
      }
    }
    .onAppear {
      if let id = UserDefaults.standard.string(forKey: "RememberMe") {
        self.spinLoginButton = true
        Task {
          do {
            let golfer = try await DatabaseCommunicator.getGolfer(id: id)
            path.append(golfer)
          } catch {
            self.spinLoginButton = false
            self.alert.0 = true
            self.alert.1 = "An issue has occured in collecting cached user data. Please Login"
          }
        }
      }
    }
  }

}

extension WelcomeAnimation {
  func login(loginInfo: LoginInfo, rememberMe: Bool) async throws -> User {
    
    
      
      let tempUser = try await Authenticator.logIn(
        emailAddress: loginInfo.emailAddress, password: loginInfo.password)
      
      if self.rememberMe {
        UserDefaults.standard.set(tempUser.uid, forKey: "RememberMe")
      } else {
        UserDefaults.standard.removeObject(forKey: "RememberMe")
      }
      
      
      return tempUser
      
    
  }
}

struct LoginDetails: View {
  @Binding var emailAddress: String
  @Binding var password: String
  @State private var isPasswordHidden = true
  
  private let strokeLength = CGFloat(2)
  private let cornerRadius = CGFloat(10)
  
  var body: some View {
    
    Group {
      TextField(
        "Email Address",
        text: self.$emailAddress
      )
      .textContentType(.emailAddress)
      .keyboardType(.emailAddress)
      .overlay {
        RoundedRectangle(cornerRadius: self.cornerRadius)
          .stroke(self.emailAddress.isEmpty ? .gray : .blue, lineWidth: self.strokeLength)
      }
      .padding(.vertical, 5)
      
      HStack {
        Group {
          if self.isPasswordHidden {
            SecureField("Password", text: self.$password)
          } else {
            TextField("Password", text: self.$password)
          }
        }
        .textContentType(.password)
        .overlay {
          RoundedRectangle(cornerRadius: self.cornerRadius)
            .stroke(self.password.isEmpty ? .gray : .blue, lineWidth: self.strokeLength)
        }
        .padding(.vertical, 5)
        
        
        
        Button {
          self.isPasswordHidden.toggle()
        } label: {
          self.isPasswordHidden ? Image(systemName: "eye") : Image(systemName: "eye.slash")
        }
        .foregroundStyle(.blue)
      }
      
      
      .animation(.easeInOut, value: self.isPasswordHidden)
    }
    
    .textFieldStyle(.roundedBorder)
    
    
  }
}



struct WelcomeAnimation_Previews: PreviewProvider {
  @State static private var user = NavigationPath()
  static var previews: some View {
    ZStack {

      

      WelcomeAnimation(path: self.$user)

    }
  }
}
