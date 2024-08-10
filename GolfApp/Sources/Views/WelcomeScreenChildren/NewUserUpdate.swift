//
//  NewUserUpdate.swift
//  GolfApp
//
//  Created by Logan Underwood on 2024-08-07.
//

import SwiftUI
import FirebaseAuth


extension String {
  func isValidEmail() -> Bool {
    /// Finds if the given email is valid. Returns true if valid false otherwise
    let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
    return regex.firstMatch(in: self, range: NSRange(location: 0, length: count)) != nil
  }
}

struct UserDefintion: View {
  @Binding var userInfo: UserInfo
  let emailData: (Color, [String])
  let passwordData: (Color, [String])
  let usernameData: (Color, [String])
  
  @State private var isPasswordHidden = true
  
  private static let cornerRadius = CGFloat(10)
  private static let strokeLength = CGFloat(2)
  private static let infoPadding = CGFloat(8)
  
  var body: some View {
    HStack {
      TextField(
        "Email Address",
        text: self.$userInfo.email
      )
      .textContentType(.emailAddress)
      .keyboardType(.emailAddress)
      .overlay {
        ZStack {
          HStack {
            Spacer()
            if !self.emailData.1.isEmpty && !self.userInfo.email.isEmpty {
              Menu {
                ForEach(self.emailData.1, id: \.self) { issue in
                  Text(issue)
                }
              } label: {
                Image(systemName: "info")
              }
              .padding(.trailing, Self.infoPadding)
            }
            
          }
          RoundedRectangle(cornerRadius: Self.cornerRadius)
            .stroke(self.emailData.0, lineWidth: Self.strokeLength)
        }
      }
      
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
        ZStack {
          HStack {
            Spacer()
            if !self.passwordData.1.isEmpty && !self.userInfo.password.isEmpty {
              Menu {
                ForEach(self.passwordData.1, id: \.self) { issue in
                  Text(issue)
                  
                }
              } label: {
                Image(systemName: "info")
              }
              .padding(.trailing, Self.infoPadding)
            }
          }
          
          RoundedRectangle(cornerRadius: Self.cornerRadius)
            .stroke(self.passwordData.0, lineWidth: Self.strokeLength)
        }
        
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
        ZStack {
          HStack {
            Spacer()
            if !self.usernameData.1.isEmpty && !self.userInfo.username.isEmpty {
              Menu {
                ForEach(self.usernameData.1, id: \.self) { issue in
                  Text(issue)
                  
                }
              } label: {
                Image(systemName: "info")
              }
              .padding(.trailing, Self.infoPadding)
            }
          }
          RoundedRectangle(cornerRadius: Self.cornerRadius)
            .stroke(self.usernameData.0, lineWidth: Self.strokeLength)
        }
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
            RoundedRectangle(cornerRadius: Self.cornerRadius)
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
            RoundedRectangle(cornerRadius: Self.cornerRadius)
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
  @State private var isCreatingUser = false
  @State private var rememberMe = true
  @Binding var showView: Bool
  
  private var emailAddressColour: Color {
    userInfoColourMap(issues: self.issuesWithData.emailIssues, data: self.newUserInfo.email)
  }
  
  
  private var passwordColour: Color {
    userInfoColourMap(issues: self.issuesWithData.passwordIssues, data: self.newUserInfo.password)
  }
  
  private var usernameColour: Color {
    userInfoColourMap(issues: self.issuesWithData.usernameIssues, data: self.newUserInfo.username)
  }
  
  func userInfoColourMap(issues: [String], data: String) -> Color {
    if data.isEmpty {
      return .gray
    }
    if issues.isEmpty {
      return .blue
    }
    
    return .red
  }
  
  @Binding var user: User?
  @State private var alert: (Bool, String?) = (false, nil)
  
  
  
  
  
  var body: some View {
    Group {
      
      UserDefintion(userInfo: self.$newUserInfo, emailData: (self.emailAddressColour, self.issuesWithData.emailIssues), passwordData: (self.passwordColour, self.issuesWithData.passwordIssues), usernameData: (self.usernameColour, self.issuesWithData.usernameIssues))
      
      Button {
        Task {
          do {
            self.user = try await self.newUserInfo.createUser()
            self.showView = false
          } catch {
            self.alert.0 = true
            self.alert.1 = error.localizedDescription
          }
        }
      } label: {
        HStack {
          if self.isCreatingUser {
            SpinningCircle(isLoading: true)
          }
          Text("Create User")
            .font(.title2)
            .bold()
            .foregroundStyle(.white)
        }
      }
      .frame(height: 50)
      .frame(maxWidth: .infinity)
      .background {
        LinearGradient(colors: [self.isValidInfo ? .green : .gray, self.isValidInfo ? .blue: .gray], startPoint: .topLeading, endPoint: .bottomTrailing)
      }
      .disabled(!self.isValidInfo)
      .clipShape(.rect(cornerRadius: 20))
    }
    .animation(.easeInOut, value: self.issuesWithData)
    .animation(.easeInOut, value: self.newUserInfo)
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
    
    .alert("Account Creation Error", isPresented: self.$alert.0, actions: {
      Button {
        self.newUserInfo.reset()
      } label: {
        Text("Retry")
      }
    }, message: {
      if let alertMessage = self.alert.1 {
        Text(alertMessage)
      } else {
        EmptyView()
      }
    })
    .textFieldStyle(.roundedBorder)
  }
}

#Preview {
  @State var showView = true
  @State var user: User?
  return NewUserFormUpdate(showView: $showView, user: $user)
}


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
        (!self.password.contains(try! Regex("[^A-Za-z0-9]")), "Must contain a special character"),
        (!self.password.contains(try! Regex("[A-Z]")), "Must contain a upper-case letter"),
        (!self.password.contains(try! Regex("[a-z]")), "Must contain a lower-case letter"),
        (!self.password.contains(try! Regex("[0-9]")), "Must contain a number")
        
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
  
  mutating func reset() {
    self.email = ""
    self.password = ""
    self.username = ""
  }
  
}
