//
//  PickACourse.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-01.
//

import SwiftUI
import FirebaseFirestore

struct PickACourse: View {
    @State private var country = Country.Canada
    
    @State private var queryResults = [Course]()
    
    @Binding var course: Course?
    var body: some View {
        VStack {
            
            GroupBox {
                HStack {
                    Text("Country:")
                        .bold()
                    Picker(selection: $country) {
                        ForEach(Country.allCases) { country in
                            Text(country.rawValue)
                        }
                    } label: {
                        Text("Choose a Country")
                    }
                }
                //TODO: come up with more filters here and maybe make this a little more modular
                //TODO: think about a struct which handles all of the filtering
            } label: {
                Label("Filters", systemImage: "rectangle.and.pencil.and.ellipsis")
                

            }
            
            GroupBox {
                Picker(selection: self.$course) {
                    ForEach(queryResults) { result in
                        /*@START_MENU_TOKEN@*/Text(result.name)/*@END_MENU_TOKEN@*/
                    }
                } label: {
                    //empty label becuase it doesn't do anything
                }
            } label: {
                Label("Select Course", systemImage: "cursorarrow")
            }
            


        }
        .onAppear {
            Task {
                try await self.queryResults.append(contentsOf: DatabaseCommunicator.getCourses())
                self.course = queryResults.randomElement()
            }
        }
        .onChange(of: course) { newCourse in
            if newCourse == nil {
                self.course = queryResults.randomElement()
            }
        }
        //TODO: Complete a set of drop down menus so you can choose from database
    }
    
}

extension PickACourse {
    
    /// A computed value which contains all of the courses which meet the provided criteria.
    var filteredResults: [Course] {
        self.queryResults.filter { course in
            return course.location.country == self.country
        }
    }
    
    
    
}

struct PickACourse_Previews: PreviewProvider {
    @State private static var course: Course?
    static var previews: some View {
        PickACourse(course: self.$course)
    }
}
