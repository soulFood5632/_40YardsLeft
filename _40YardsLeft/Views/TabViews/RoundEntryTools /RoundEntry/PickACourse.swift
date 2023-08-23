//
//  PickACourse.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-01.
//

import SwiftUI
import FirebaseFirestore

struct PickACourse: View {

    @Binding var path: NavigationPath
    @State private var chosenCourse: Course?
    
    
    //TODO: default to current location.
    
    var body: some View {
        VStack {
            
            
            CourseFilter(chosenCourse: self.$chosenCourse, path: self.$path)
            
                .padding([.top, .horizontal])
                .padding(.bottom, 6)
            
            Button {
                path.append(chosenCourse!)
            } label: {
                Label("Confirm", systemImage: "checkmark")
            }
            .buttonStyle(.borderedProminent)
            .disabled(chosenCourse == nil)
        }
            
            

    }
    
}



struct PickACourse_Previews: PreviewProvider {
    @State private static var path = NavigationPath()
    static var previews: some View {
        PickACourse(path: self.$path)
    }
}
