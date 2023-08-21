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

    //TODO: add more filters as needed here
    
    init() {
        //TODO: add get current province and country. It should default to current location.
        self.country = .Canada
        self.province = .BC
    }
    
    
}

struct CourseFilter: View {
    
    @Binding var chosenCourse: Course?
    @Binding var path: NavigationPath
    
    @State private var filter = Filters()
    @State private var isLoading = true
    @State private var courseQuery = [Course]()
    @State private var isQueryReady = false
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
            
            if let chosenCourse {
                
                
                Text(chosenCourse.name)
                    .font(.headline)
                Text(chosenCourse.location.city + ", " + chosenCourse.location.province.rawValue)
                    .font(.subheadline)
                
            }
            
//            NavigationLink(value: self.courseQuery) {
//                if self.chosenCourse == nil {
//                    Label("Search", systemImage: "magnifyingglass")
//
//                } else {
//                    Label("Edit", systemImage: "pencil")
//                        .padding(.top, 3)
//                }
//            }
                
            
            Button {
//                print("adding \(courseQuery.debugDescription)")
//                path.append(self.courseQuery)
                self.isQueryReady = true
            } label: {
                if self.chosenCourse == nil {
                    Label("Search", systemImage: "magnifyingglass")
                    
                } else {
                    Label("Edit", systemImage: "pencil")
                        .padding(.top, 3)
                }
            }
            .buttonStyle(.borderless)
            .padding(.top, 2)
            .disabled(self.isLoading)
            
        }
        
        .sheet(isPresented: self.$isQueryReady, onDismiss: {
            self.courseQuery = []
        }, content: {
            CourseSearcher(overallQuery: self.courseQuery, chosenCourse: self.$chosenCourse, path: self.$path, showView: self.$isQueryReady)
        })
//        .navigationDestination(for: [Course].self) { courseList in
//            CourseSearcher(overallQuery: courseList, chosenCourse: self.$chosenCourse, path: self.$path)
//        }
        .animation(.easeInOut, value: self.chosenCourse)
        .animation(.spring(dampingFraction: 0.6), value: self.isLoading)
        .onAppear {
            self.searchDatabase()
        }
        .onChange(of: self.filter.country) {
            newCountry in
            
            self.chosenCourse = nil

        }
        .onChange(of: self.filter.province) { newProvince in
            precondition(self.filter.country.getPairedProvinces().contains(newProvince))
            
            self.searchDatabase()
            
            self.chosenCourse = nil
        }
//        .onChange(of: self.courseQuery) { query in
//            self.isQueryReady = !query.isEmpty
//        }
        
        
        
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
            
            self.isLoading = false
        }
    }
}






struct CourseFilter_Previews:
PreviewProvider {
    
    @State private static var course: Course?
    @State private static var path = NavigationPath()
    static var previews: some View {
        CourseFilter(chosenCourse: $course, path: self.$path)
    }
}
