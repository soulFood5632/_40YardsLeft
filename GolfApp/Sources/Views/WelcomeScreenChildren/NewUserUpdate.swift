//
//  NewUserUpdate.swift
//  GolfApp
//
//  Created by Logan Underwood on 2024-08-07.
//

import SwiftUI
import FirebaseAuth



struct UserInfo: Equatable {
  
  struct EntryIssue: Equatable {
    var emailIssues: [String]
    var passwordIssues: [String]
    var usernameIssues: [String]
    
    func allIssues() -> [String] {
      return emailIssues + passwordIssues + usernameIssues
    }
    
  }
  var password: String
  var email: String
  var username: String
  var gender: Gender
  
  static let PASSWORD_LENGTH = 7
  static let USERNAME_LENGTH = (3, 15)
  
  init(password: String, email: String, username: String, gender: Gender) {
    self.password = password
    self.email = email
    self.username = username
    self.gender = gender
  }
  
  init() {
    self.password = ""
    self.email = ""
    self.username = ""
    self.gender = .man
  }
  
  func isValid() async -> UserInfo.EntryIssue {
    
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
      
      let condition_list = [
        (self.username.count < Self.USERNAME_LENGTH.0, "Username must have \(Self.USERNAME_LENGTH.0) characters"),
        (self.username.count > Self.USERNAME_LENGTH.1, "Username must have less than \(Self.USERNAME_LENGTH.1) characters"),
        (self.username.contains("[^A-Za-z0-9]"), "Username must be numbers and letters")
        
      ]
      
      return condition_list.filter { $0.0 }.map { $0.1 }
      
    }
    
    
    
    return await UserInfo.EntryIssue(emailIssues: email_valid.value, passwordIssues: password_valid.value, usernameIssues: username_valid.value)
    
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

struct UserDefintion: View {
  @Binding var userInfo: UserInfo
  
  @State private var isPasswordHidden = true
  
  private let cornerRadius = CGFloat(10)
  private let strokeLength = CGFloat(2)
  
  var body: some View {
    TextField(
      "Email Address",
      text: self.$userInfo.email
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
          SecureField("Password", text: self.$userInfo.password)
        } else {
          TextField("Password", text: self.$userInfo.password)
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
    
    TextField("Username", text: self.$userInfo.username)
      .textContentType(.name)
      .overlay {
        RoundedRectangle(cornerRadius: self.cornerRadius)
          .stroke(.blue, lineWidth: self.strokeLength)
      }
    
    HStack {
      Spacer()
      Text("Man")
        .onTapGesture {
          self.userInfo.gender = .man
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 3)
        .background {
          if self.userInfo.gender == .man {
            RoundedRectangle(cornerRadius: self.cornerRadius)
              .opacity(0.1)
              .blur(radius: 1)
          }
        }
        .foregroundStyle(self.userInfo.gender == .man ? .blue : .gray)
      
      
      
      Text("Woman")
        .onTapGesture {
          self.userInfo.gender = .woman
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 3)
        .background {
          if self.userInfo.gender == .woman {
            RoundedRectangle(cornerRadius: self.cornerRadius)
              .opacity(0.1)
              .blur(radius: 1)
          }
        }
        .foregroundStyle(self.userInfo.gender == .woman ? .blue : .gray)
      
      Menu {
        Text("The gender you would use for handicap calculations")
      } label: {
        Image(systemName: "info")
      }
      Spacer()
    }
    
  }
}

struct NewUserFormUpdate: View {
  @State private var newUserInfo = UserInfo()
  @State private var issuesWithData = UserInfo.EntryIssue(emailIssues: [], passwordIssues: [], usernameIssues: [])
  
  private var isValidInfo: Bool { issuesWithData.allIssues().isEmpty }

  @State private var rememberMe = true
  @Binding var showView: Bool
  
  
  @Binding var user: User?
  @State private var alert: (Bool, String?) = (false, nil)
  
  
  
  
  
  var body: some View {
    Group {
      
      UserDefintion(userInfo: self.$newUserInfo)
      
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
        LinearGradient(colors: [self.isValidInfo ? .green : .gray, self.isValidInfo ? .blue: .gray], startPoint: .topLeading, endPoint: .bottomTrailing)
      }
      .disabled(!self.isValidInfo)
      .clipShape(.rect(cornerRadius: 20))
    }
    .animation(.easeInOut, value: self.newUserInfo.gender)
    .padding(.horizontal)
    .padding(.vertical, 3)
    .onChange(of: self.newUserInfo, { oldValue, newValue in
      Task {
        self.issuesWithData = await newValue.isValid()
      }
    })
    .onAppear {
      Task {
        self.issuesWithData = await self.newUserInfo.isValid()
      }
    }
    .textFieldStyle(.roundedBorder)
  }
}

#Preview {
  @State var showView = true
  @State var user: User?
  return NewUserFormUpdate(showView: $showView, user: $user)
}
