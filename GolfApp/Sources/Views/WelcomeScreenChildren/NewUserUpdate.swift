//
//  NewUserUpdate.swift
//  GolfApp
//
//  Created by Logan Underwood on 2024-08-07.
//

import SwiftUI
import FirebaseAuth

struct NewUserInfo: Equatable {
  var password: String
  var email: String
  var username: String
  var gender: Gender
  
  static let PASSWORD_LENGTH = 7
  static let USERNAME_LENGTH = (3, 15)
  
  func isValid() async -> [String: [String]] {
    
    // email logic
    let email_valid = Task {
      if !self.email.isValidEmail() {
        return ["Invalid Email Address"]
      }
      return []
    }
    
    //password logic
    let password_valid = Task {
      
      
      let condition_mapping = [
        (self.password.count < Self.PASSWORD_LENGTH, "Must have \(Self.PASSWORD_LENGTH) characters"),
        (!self.password.contains("[^A-Za-z0-9]"), "Must contain a special character"),
        (!self.password.contains("[A-Z]"), "Must contain a upper-case letter"),
        (!self.password.contains("[a-z]"), "Must contain a lower-case letter"),
        (!self.password.contains("[0-9]"), "Must contain a number")
      
      ]
      
      return condition_mapping.filter { $0.0 }.map { $0.1 }
    
    }
    
    // username logic
    let username_valid = Task {
      
      condition_list = [
        (self.username.count < Self.USERNAME_LENGTH.0, "Username must have \(Self.USERNAME_LENGTH.0) characters"),
        (self.username.count > Self.USERNAME_LENGTH.1, "Username must have less than \(Self.USERNAME_LENGTH.1) characters"),
        (self.username)
        
      ]
      
    }
    
  } //TODO: complete the logic here.
  
  func createUser() async throws -> User {
    return try await Authenticator.createUser(emailAddress: self.email, password: self.password)
  }
  
}

extension String {
  func isValidEmail() -> Bool {
    /// Finds if the given email is valid. Returns true if valid false otherwise
    let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
    return regex.firstMatch(in: self, range: NSRange(location: 0, length: count)) != nil
  }
}

struct NewUserFormUpdate: View {
  @State private var newUserInfo = NewUserInfo(password: "", email: "", username: "", gender: .man)

  @State private var rememberMe = true
  @Binding var showView: Bool
  @State private var isPasswordHidden = true
  
  @Binding var user: User?
  @State private var alert: (Bool, String?) = (false, nil)
  
  private let cornerRadius = CGFloat(10)
  private let strokeLength = CGFloat(2)
  
  
  
  var body: some View {
    Group {
      TextField(
        "Email Address",
        text: self.$newUserInfo.email
      )
      .textContentType(.emailAddress)
      .keyboardType(.emailAddress)
      .overlay {
        RoundedRectangle(cornerRadius: self.cornerRadius)
          .stroke(.blue, lineWidth: self.strokeLength)
      }
      
      
      HStack {
        Group {
          if self.isPasswordHidden {
            SecureField("Password", text: self.$newUserInfo.password)
          } else {
            TextField("Password", text: self.$newUserInfo.password)
          }
        }
        .textContentType(.password)
        .overlay {
          RoundedRectangle(cornerRadius: self.cornerRadius)
            .stroke(.blue, lineWidth: self.strokeLength)
        }
        
        
        
        
        Button {
          self.isPasswordHidden.toggle()
        } label: {
          self.isPasswordHidden ? Image(systemName: "eye") : Image(systemName: "eye.slash")
        }
        
      }
      .animation(.easeInOut, value: self.isPasswordHidden)
      
      TextField("Username", text: self.$newUserInfo.username)
        .textContentType(.name)
        .overlay {
          RoundedRectangle(cornerRadius: self.cornerRadius)
            .stroke(.blue, lineWidth: self.strokeLength)
        }
      
      HStack {
        Spacer()
        Text("Man")
          .onTapGesture {
            self.newUserInfo.gender = .man
          }
          .padding(.horizontal, 10)
          .padding(.vertical, 3)
          .background {
            if self.newUserInfo.gender == .man {
              RoundedRectangle(cornerRadius: self.cornerRadius)
                .opacity(0.1)
                .blur(radius: 1)
            }
          }
          .foregroundStyle(self.newUserInfo.gender == .man ? .blue : .gray)
        
          
        
        Text("Woman")
          .onTapGesture {
            self.newUserInfo.gender = .woman
          }
          .padding(.horizontal, 10)
          .padding(.vertical, 3)
          .background {
            if self.newUserInfo.gender == .woman {
              RoundedRectangle(cornerRadius: self.cornerRadius)
                .opacity(0.1)
                .blur(radius: 1)
            }
          }
          .foregroundStyle(self.newUserInfo.gender == .woman ? .blue : .gray)
          
        Menu {
          Text("The gender you would use for handicap calculations")
        } label: {
          Image(systemName: "info")
        }
        
        

        Spacer()
      }
      
      Button {
        Task {
          do {
            self.user = try await self.newUserInfo.createUser()
          } catch {
            self.alert.0 = true
            self.alert.1 = error.localizedDescription
          }
        }
      } label: {
        Text("Create User")
          .font(.title2)
          .bold()
          .foregroundStyle(.white)
      }
      .frame(height: 50)
      .frame(maxWidth: .infinity)
      .background {
        LinearGradient(colors: [self.newUserInfo.isValid.isEmpty ? .green : .gray, self.newUserInfo.isValid.isEmpty ? .blue: .gray], startPoint: .topLeading, endPoint: .bottomTrailing)
      }
      .clipShape(.rect(cornerRadius: 20))
    }
    .animation(.easeInOut, value: self.newUserInfo.gender)
    .padding(.horizontal)
    .padding(.vertical, 3)
    
    .textFieldStyle(.roundedBorder)
  }
}

#Preview {
  @State var showView = true
  @State var user: User?
  return NewUserFormUpdate(showView: $showView, user: $user)
}
