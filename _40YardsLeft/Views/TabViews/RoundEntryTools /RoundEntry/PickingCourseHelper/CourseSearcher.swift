//
//  CourseSearcher.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-05-01.
//

import SwiftUI

struct CourseSearcher: View {
    let overallQuery: [Course]
    @State private var filteredQuery = [Course]()
    
    @Binding var chosenCourse: Course?
    @State private var searchText = ""
    @Binding var path: NavigationPath
    @Binding var showView: Bool
    
    
    var body: some View {
        VStack {

            List {
                ForEach(filteredQuery, id: \.name) { course in
                    let isSelected = self.chosenCourse == course
                    HStack {
                        VStack (alignment: .leading) {
                            
                            Text(course.name)
                                .font(.headline)
                            
                            Text(course.location.city + ", " + course.location.province.rawValue)
                                .font(.subheadline)
                            
                        }
                        Spacer()
                        if isSelected {
                            Image(systemName: "checkmark.circle")
                        } else {
                            Image(systemName: "circle")
                        }
                    }
                    .foregroundColor(self.chosenCourse == course ? .primary : .secondary)
                    .onTapGesture {
                        if isSelected {
                            self.chosenCourse = nil
                        } else {
                            self.chosenCourse = course
                        }
                    }
                }
            }
            
            if filteredQuery.isEmpty {
                GroupBox {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.title)
                        .bold()
                    Text("No Matching Courses")
                        .font(.title)
                        .bold()
                        
                        .backgroundStyle(.red)
                }
                
                Button {
//                    path.removeLast()
                    showView = false
                } label: {
                    Text("New Search")
                }
                
            } else {
                Button {
//                    path.removeLast()
                    showView = false
                } label: {
                    Text("Confirm")
                }
                .disabled(chosenCourse == nil)
                .buttonStyle(.borderedProminent)
                .padding()
            }
            
            
            
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("Search")
        .animation(.easeInOut, value: self.chosenCourse)
        .animation(.easeInOut, value: self.filteredQuery)
        .searchable(text: self.$searchText)
        .onAppear {
            self.filteredQuery = self.overallQuery
        }
        .onChange(of: self.searchText) { searchText in
            if searchText.isEmpty {
                self.filteredQuery = overallQuery
            } else {
                
                self.filteredQuery = overallQuery
                    .filter { $0.name.lowercased().hasPrefix(self.searchText.lowercased()) }
                    
            }
        }
    }
}



struct CourseSearcher_Previews: PreviewProvider {
    @State private static var chosenOne: Course?
    @State private static var showScreen = true
    @State private static var path = NavigationPath()
    @State private static var view = true
    
    static var previews: some View {
        NavigationStack {
            CourseSearcher(overallQuery: [Course.example1], chosenCourse: self.$chosenOne, path: self.$path, showView: $view)
        }
    }
}
