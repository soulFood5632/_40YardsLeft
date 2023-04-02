//
//  BasicCourseInfo.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-01.
//

import SwiftUI

struct BasicCourseInfo: View {
    @Binding var buffer: CourseBuffer
    
    var body: some View {
        Grid(alignment: .leading) {
            GridRow {
                LabelAndField(prompt: "Address", text: self.$buffer.addressLine1)
                    
            }
            
            GridRow {
                LabelAndField(prompt: "City", text: self.$buffer.city)
                
            }
            
            
            GridRow {
                //TODO: think of structure to add the province and country
            }
            
            GridRow {
                LabelAndField(prompt: "Name", text: self.$buffer.name)
            }
        }
    }
}

struct LabelAndField: View {
    let prompt: String
    @Binding var text: String
    
    var body: some View {
        Text(prompt + ":")
        TextField(prompt, text: self.$text)
            .textFieldStyle(.roundedBorder)
    }
    
}

struct BasicCourseInfo_Previews: PreviewProvider {
    @State private static var buffer = CourseBuffer()
    static var previews: some View {
        BasicCourseInfo(buffer: self.$buffer)
    }
}
