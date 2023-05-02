//
//  PickACourse.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-01.
//

import SwiftUI
import FirebaseFirestore

struct PickACourse: View {
    
    
    @Binding var course: Course?
    @State private var chosenCourse: Course?
    
    
    //TODO: default to current location.
    
    var body: some View {
        VStack {
            
            
                CourseFilter(chosenCourse: self.$chosenCourse)
            
            .padding()
            
            Button {
                course = chosenCourse
            } label: {
                Label("Save", systemImage: "checkmark")
            }
            .disabled(chosenCourse == nil)
        }
            
            
            
            
        //TODO: Complete a set of drop down menus so you can choose from database
    }
    
}



struct PickACourse_Previews: PreviewProvider {
    @State private static var course: Course?
    static var previews: some View {
        PickACourse(course: self.$course)
    }
}
