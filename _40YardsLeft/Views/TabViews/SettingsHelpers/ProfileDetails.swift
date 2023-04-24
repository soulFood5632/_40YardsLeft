//
//  ProfileDetails.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-17.
//

import SwiftUI

struct ProfileBuffer {
    var userName: String
    var homeCourse: Course?
    
    init(userName: String, homeCourse: Course? = nil) {
        self.userName = userName
        self.homeCourse = homeCourse
    }
    
    init(golfer: Golfer) {
        self.userName = golfer.name
        self.homeCourse = golfer.homeCourse
    }
}

struct ProfileDetails: View {
    @Binding var golfer: Golfer
    @State var profileBuffer: ProfileBuffer
    
    @State private var isChangeComplete = [false, false]
    
    
    var body: some View {
        VStack {
            HStack {
                Text("Username:")
                    .bold()
                    .padding(.trailing, 8)
                EditableStaticText(text: $profileBuffer.userName, isConfirmed: self.$isChangeComplete[0], originalText: profileBuffer.userName)
                    .textFieldStyle(.roundedBorder)
            }
            Divider()
            if profileBuffer.homeCourse == nil {
                NavigationLink {
                    PickACourse(course: self.$profileBuffer.homeCourse)
                        .padding()
                } label: {
                    Label("Add your home course", systemImage: "link.badge.plus")
                }
            } else {
                
            }

        }
    }
}

struct ProfileDetails_Previews: PreviewProvider {
    @State static private var golfer = Golfer.golfer
    static var previews: some View {
        ProfileDetails(golfer: self.$golfer, profileBuffer: .init(golfer: self.golfer))
    }
}
