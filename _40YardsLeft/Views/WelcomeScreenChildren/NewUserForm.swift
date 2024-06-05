//
//  NewUserForm.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-18.
//

import SwiftUI
import FirebaseAuth

struct NewUserForm: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordChecker: String = ""
    @State private var name = ""
    @State private var gender = Gender.man
    //TODO: Add home course
    @FocusState private var focuser: FocusedFeild?
    @State private var remeberMe = true
    @Binding var showView: Bool
    
    @Binding var user: User?
    @State private var showAlert: (Bool, String?) = (false, nil)
    
    @State private var isValidEntries = [false, false, false, false]
    
    //MARK: New User form body
    var body: some View {
        VStack {
            
            
            Group {
                
                let mustNotBeEmpty = TextValiditity.betweenSizes(range: 1..<15)
                TextFieldWithValiditity(condition: mustNotBeEmpty,
                                        text: self.$name, prompt: "Username",
                                        isSecureField: false,
                                        isValid: self.$isValidEntries[0])
                    .submitLabel(.next)
                    .focused(self.$focuser, equals: .username)
                    .onSubmit {
                        self.focuser = .email
                    }
                
                TextFieldWithValiditity(condition: TextValiditity.emailChecker, text: self.$email, prompt: "Email Address", isSecureField: false, isValid: self.$isValidEntries[1])
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .submitLabel(.next)
                    .focused(self.$focuser, equals: .email)
                    .onSubmit {
                        self.focuser = .password1
                    }
                    
                TextFieldWithValiditity(condition: TextValiditity.passwordCheck, text: self.$password, prompt: "Password", isSecureField: true, isValid: self.$isValidEntries[2])
                    .textContentType(.newPassword)
                    .submitLabel(.next)
                    .focused(self.$focuser, equals: .password1)
                    .onSubmit {
                        self.focuser = .password2
                    }
                
                let condition: (String) -> [String] = { entry in
                    if entry != self.password {
                        return ["Passwords Do Not Match"]
                    }
                    return []
                }
                
                TextFieldWithValiditity(condition: condition, text: self.$passwordChecker, prompt: "Re-Enter Password", isSecureField: true, isValid: self.$isValidEntries[3])
                    .textContentType(.newPassword)
                    .focused(self.$focuser, equals: .password2)
                
                HStack {
                    Text("Select Gender")
                        .font(.callout)
                    
                    Image(systemName: "figure.dress.line.vertical.figure")
                    Spacer()
                    Picker(selection: self.$gender) {
                        ForEach(Gender.allCases) { gender in
                            Text(gender.rawValue)
                        }
                    } label: {
                        Text("Select Gender")
                    }
                }
                
                HStack {
                    Text("Save Login")
                        .bold()
                    Toggle("", isOn: self.$remeberMe)
                        .labelsHidden()
                        .toggleStyle(.switch)
                }
                .padding(.bottom, 7)
                .padding(.vertical, 2)
                
                
                
                    
            }
            .onChange(of: self.isValidEntries, perform: { newValue in
                print(isValidEntries)
            })
            .textFieldStyle(.roundedBorder)
            .padding(.vertical, 1.5)
            
            
            Button {
                
                Task {
                    
                    var tempUser: User?
                    do {
                        
                        tempUser = try await Authenticator.createUser(emailAddress: email, password: self.password)
                        
                        //TODO: deal with errors in creating users
                        
                        if self.remeberMe {
                            UserDefaults.standard.set(tempUser!.uid, forKey: "RememberMe")
                        } else {
                            UserDefaults.standard.removeObject(forKey: "RememberMe")
                        }
                        
                        withAnimation (.easeInOut(duration: 1)) {
                            self.user = tempUser!
                        }
                        
                        
                        
                        
                        
                    } catch {
                        self.showAlert.1 = error.localizedDescription
                        self.showAlert.0 = true
                        
                    }
                    
                    do {
                        if tempUser != nil {
                            let newGolfer = Golfer(firebaseID: tempUser!.uid, gender: self.gender, name: self.name)
                            
                            _ = try await DatabaseCommunicator.addGolfer(golfer: newGolfer)
                        }
                    } catch {
                        print(error.localizedDescription)
                        //Deal with this error here
                    }
                    
                }
                
            } label: {
                Text("Make Account")
            }
            .disabled(!isValidEntry())
            .buttonStyle(.borderedProminent)
            
            
            
           
            
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .opacity(0.95)
                
        }
        .alert("Account Creation Error", isPresented: self.$showAlert.0, actions: {
            Button {
                withAnimation {
                    self.resetFields()
                }
            } label: {
                Text("Retry")
            }

        }, message: {
            Text(self.showAlert.1 ?? "Unknown Error")
        })
        .padding()
    }
}

enum FocusedFeild : Hashable {
    case username, email, password1, password2
}

extension NewUserForm {
    
    /// Gets if the all of the entry forms meet their provided criteria.
    ///
    /// - Returns: True if all criterion are met, false otherwise.
    private func isValidEntry() -> Bool {
        return !self.isValidEntries.contains(false)
    }
    
    private func resetFields() {
        self.password = ""
        self.passwordChecker = ""
        self.email = ""
        self.name = ""
    }
}

struct NewUserForm_Previews: PreviewProvider {
    @State static private var user: User?
    @State static private var showView = true
  
    static var previews: some View {
        
        ZStack {
            RadialBackground()
            NewUserForm(showView: self.$showView, user: self.$user)
        }
    }
}
