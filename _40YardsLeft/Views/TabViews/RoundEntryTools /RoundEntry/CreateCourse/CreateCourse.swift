//
//  CreateCourse.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-01.
//

import SwiftUI

struct CourseBuffer {
    var addressLine1 = ""
    var city = ""
    var provice: Province
    var country: Country
    var name = ""
    
    init() {
        //TODO: make this based on current location
        self.provice = .BC
        self.country = .Canada
    }
}


struct CreateCourse: View {

    
    @Binding var showView: Bool
    @Binding var path: NavigationPath
    
    @State private var buffer = CourseBuffer()
    
    
    var body: some View {
        VStack {
            
            
            GroupBox {
                
                BasicCourseInfo(buffer: self.$buffer)
                
            } label: {
                Label("Course Info", systemImage: "house.and.flag")
            }
            
            
            
            HStack {
                
                Button {
                    //TODO: add action to drop out of this view and populate bottom view with this new course
                    self.showView = false
                    path.append(createCourse())
                    
                    
                } label: {
                    Label("Save", systemImage: "square.and.arrow.down")
                }
                .disabled(!self.courseReady)
            }
        }
        .padding()
    }
}

extension CreateCourse {
    
    /// - Throws: `inavlidSlope` when the slope is invalid
    /// - Throws: `inavlidRating` when the rating is invalid
    /// - Throws: `tooManyHoles` when the number of holes provided is larger than 18
    /// - Throws: `inavlidHandicap` when the handicaps are not entered correctly, either there are duplicates or there is values which are not between 1 and 18.
    private func createCourse() -> Course {
        
            
            
            let courseInfoBuffer = self.buffer
            
            return Course(location: Address(addressLine1: courseInfoBuffer.addressLine1,
                                                               city: courseInfoBuffer.city,
                                                               province: courseInfoBuffer.provice, country: courseInfoBuffer.country), name: courseInfoBuffer.name)
        
    }
    
    var courseReady: Bool {
        return !buffer.name.isEmpty && !buffer.city.isEmpty && !buffer.addressLine1.isEmpty
    }
}

struct CreateCourse_Previews: PreviewProvider {
    @State private static var path = NavigationPath()
    @State private static var showView = true
    static var previews: some View {
        CreateCourse(showView: self.$showView, path: self.$path)
    }
}
