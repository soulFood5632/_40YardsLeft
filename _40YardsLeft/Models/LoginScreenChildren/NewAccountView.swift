//
//  NewAccountView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-15.
//

import SwiftUI

struct NewAccountView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var passwordCheck = ""
    
    var body: some View {
        NavigationStack {
            
            
                List {
                    Section {
                        TextField("Username", text: self.$username)
                        TextField("Email", text: self.$email)
                        
                        TextField("Password", text: self.$password)
                        TextField("Re-enter Password", text: self.$passwordCheck)
                    } header: {
                        Text("Account Details")
                            .bold()
                    }
                    
                    
                }
                .toolbar {
                    ToolbarItem (placement: .confirmationAction) {
                        Button {
                            Task {
                                //API call
                            }
                        } label: {
                            Text("Save")
                        }
                        
                        
                    }
                    
                    ToolbarItem (placement: .cancellationAction) {
                        Button (role: .destructive) {
                            Task {
                                //API call
                            }
                        } label: {
                            Text("Cancel")
                        }
                        
                        .foregroundColor(.red)
                    }
                }

            
            
            
            

            
            Spacer()
        }
            
            

        
    }
}

struct NewAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NewAccountView()
    }
}
