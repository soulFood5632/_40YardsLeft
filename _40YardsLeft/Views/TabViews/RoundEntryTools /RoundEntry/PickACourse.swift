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
    
    @State private var chosenCourse: Course?
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
            if self.chosenCourse != nil {
                GroupBox {
                    

                    Picker(selection: self.unwrappedChosenCourseBinding) {
                        ForEach(queryResults) { result in
                            /*@START_MENU_TOKEN@*/Text(result.name)/*@END_MENU_TOKEN@*/
                        }
                    } label: {
                        //empty label becuase it doesn't do anything
                    }
                    
                    Button {
                        withAnimation {
                            self.course = self.chosenCourse
                        }
                    } label: {
                        Label("Save Course", systemImage: "checkmark")
                    }
                    .buttonStyle(.bordered)
                } label: {
                    Label("Select Course", systemImage: "cursorarrow")
                }
                .animation(.easeInOut, value: self.chosenCourse)
            }
            


        }
        .onAppear {
            Task {
                try await self.queryResults.append(contentsOf: DatabaseCommunicator.getCourses())
                self.chosenCourse = queryResults.first
            }
        }
        .onChange(of: self.queryResults) { newQuery in
            if let chosenCourse = self.chosenCourse {
                if !newQuery.contains(chosenCourse) {
                    self.chosenCourse = queryResults.first
                }
            }
        }
        .onChange(of: chosenCourse) { newCourse in
            if newCourse == nil {
                self.chosenCourse = queryResults.first
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
    
    private var unwrappedChosenCourseBinding: Binding<Course> {
        Binding {
            self.chosenCourse!
        } set: { newCourse in
            self.chosenCourse = newCourse
        }

    }
    
    
    
}

struct PickACourse_Previews: PreviewProvider {
    @State private static var course: Course?
    static var previews: some View {
        PickACourse(course: self.$course)
    }
}
