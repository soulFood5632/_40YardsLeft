//
//  CourseFilter.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-09.
//

import SwiftUI

struct Filters: Equatable {
    var country: Country
    var province: Province
    var name: String
    //TODO: add more filters as needed here
    
    init() {
        //TODO: add get current province and country. It should default to current location.
        self.country = .Canada
        self.province = .BC
        self.name = ""
    }
    
    mutating func resetName() {
        self.name = ""
    }
}

struct CourseFilter: View {
    
    @Binding var chosenCourse: Course?
    
    @State private var filter = Filters()
    @State private var isLoading = true
    @State private var courseQuery = [Course]()
    @State private var presentedQuery = [Course]()
    @State private var databaseError: (Bool, String?) = (false, nil)
    
    
    
    var body: some View {
        VStack {
            Grid (alignment: .leading) {
                GridRow {
                    
                    PickerAndLabel(pickedElement: self.$filter.country, choices: Country.allCases, title: "Country")
                    
                }
                
                GridRow {
                    
                    PickerAndLabel(pickedElement: self.$filter.province, choices: self.filter.country.getPairedProvinces(), title: "Province/State")
                    
                }
            }
            
            
            if chosenCourse == nil {
                
                ZStack {
                    
                    TextField("Course Name", text: self.$filter.name, prompt: Text("Course Name"))
                        .textFieldStyle(.roundedBorder)
                        .disabled(self.isLoading)
                    
                    
                    //TODO: think about Human factors of downtime. 
                }
                
            } else {
                // safely unrappwed due to if statment flow.
                HStack {
                    Text(chosenCourse!.name)
                        .bold()
                    Text(chosenCourse!.location.city + ", " + chosenCourse!.location.province.rawValue)
                    
                    Button {
                        
                        chosenCourse = nil
                        
                        self.filter.resetName()
                    } label: {
                        Image(systemName: "pencil")
                    }
                    
                }
                
            }
            
            
            if
                !self.filter.name.isEmpty && self.chosenCourse == nil {
                List {
                    ForEach(presentedQuery) { course in
                        HStack {
                            Text(course.name)
                                .bold()
                            Divider()
                            Text(course.location.city)
                        }
                        .onTapGesture {
                            
                            self.chosenCourse = course
                            
                        }
                    }
                    
                }
            }
            
            //TODO: Spinning circle
        }
        .animation(.easeInOut, value: self.chosenCourse)
        .animation(.easeInOut, value: self.presentedQuery)
        .animation(.spring(dampingFraction: 0.6), value: self.isLoading)
        .animation(.easeInOut, value: self.filter.name)
        .onAppear {
            self.searchDatabase()
        }
        .onChange(of: self.filter.country) {
            newCountry in
            //TODO: make get closest province function and give the filter.province that value.
            
            self.filter.resetName()
            self.chosenCourse = nil
            
            
            
        }
        .onChange(of: self.filter.province) { newProvince in
            precondition(self.filter.country.getPairedProvinces().contains(newProvince))
            
            self.searchDatabase()
            
            self.filter.resetName()
            self.chosenCourse = nil
        }
        .onReceive(self
            .filter
            .name
            .publisher
            .debounce(for: 0.5, scheduler: RunLoop.main)
        ) { newCourseName in
            //TODO: fix the jankiness of the lower case bullshit.
            if newCourseName.lowercased().isEmpty {
                presentedQuery = self.courseQuery
            } else {
                presentedQuery = self.courseQuery
                    .filter { $0.name.lowercased().hasPrefix(newCourseName.lowercased()) }
            }
        }
        
        
    }
}


    
    

extension CourseFilter {
    
    /// Searches the database with the current filters and populates the query.
    ///
    /// During search times `self.isLoading` will be set to true, and false at the end.
    private func searchDatabase() {
        self.isLoading = true
        Task {
            do {
                self.courseQuery = try await DatabaseCommunicator.getCoursesFromFilter(filter).sorted(by: { no1, no2 in
                    no1.name > no2.name
                })
                
            } catch {
                self.databaseError = (true, error.localizedDescription)
            }
            //TODO: Ensure that this section is not bugged.
            self.presentedQuery = self.courseQuery
            
            self.isLoading = false
        }
    }
}






struct CourseFilter_Previews:
PreviewProvider {
    
    @State private static var course: Course?
    static var previews: some View {
        CourseFilter(chosenCourse: $course)
    }
}
