//
//  ProfileView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-09-01.
//

import SwiftUI

struct ProfileView: View {
    @State var golfer: Golfer
    @State private var newCourseView = false
    @State private var newCourseBuffer: Course?

    
    
    var body: some View {
        VStack {
            GroupBox {
                VStack {
                    Grid(alignment: .leading, horizontalSpacing: 13) {
                        GridRow {
                            Text("Username:")
                                .bold()
                            TextField("Username", text: self.$golfer.name)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        GridRow {
                            
                            Text("Gender:")
                                .bold()
                            
                            Picker(selection: self.$golfer.gender) {
                                ForEach(Gender.allCases) { gender in
                                    Text(gender.rawValue)
                                }
                            } label: {
                                Text("Gender")
                            }
                        }
                        
                        GridRow {
                            if let homeCourse = self.golfer.homeCourse {
                                
                                Text("Home Course:")
                                    .bold()
                                
                                HStack {
                                    Text(homeCourse.name)
                                        .multilineTextAlignment(.leading)
                                    Button {
                                        self.newCourseBuffer = homeCourse
                                        self.newCourseView = true
                                    } label: {
                                        Image(systemName: "pencil")
                                    }
                                }
                            }
                        }
                    }
                    
                if self.golfer.homeCourse == nil {
                        Button {
                            self.newCourseView = true
                        } label: {
                            Label("Add Home Course", systemImage: "plus")
                        }
                    }
                }
                
            } label: {
                Label("Profile", systemImage: "person.circle")
                    .font(.title2)
                    .bold()
            }
            .sheet(isPresented: self.$newCourseView) {
                VStack {
                    
                    CourseFilter(chosenCourse: self.$newCourseBuffer)
                    
                        .padding([.top, .horizontal])
                        .padding(.bottom, 6)
                    
                    Button {
                        self.golfer.homeCourse = self.newCourseBuffer
                        self.newCourseView = false
                    } label: {
                        Label("Confirm", systemImage: "checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(newCourseBuffer == nil)
                }
            }
            
            GroupBox {
                
                Text("TBA")
                    .bold()
//                List(self.userDefaultsBindings.keys.sorted(), id: \.hashValue) { key in
//
//                    HStack {
//
//                        Text(key)
//
//                        Spacer()
//
//                        TextField("y.", value: self.userDefaultsBindings[key]!, formatter: .wholeNumber)
//                            .multilineTextAlignment(.trailing)
//                            .frame(width: 75)
//
//                    }
//
//                }
                
               
            } label: {
                Label("Preferences", systemImage: "slider.horizontal.3")
                    .font(.title2)
                    .bold()
            }
            
            
        }
        .padding()
        
       
    }
}

extension ProfileView {
    var userDefaultsBindings: [String: Binding<Double>] {
        [
            "Driving Distance (y.)":
            Binding {
                self.golfer.userDistanceSettings.driveDistance.yards
            } set: { newValue in
                self.golfer.userDistanceSettings.driveDistance = .yards(newValue)
                
            },
        
            "Max Approach (y.)":
            Binding {
                self.golfer.userDistanceSettings.maximumApproachDistance.yards
            } set: { newValue in self.golfer.userDistanceSettings.maximumApproachDistance = .yards(newValue)
            },
            
            "Min Approach (y.)":
                Binding {
                    self.golfer.userDistanceSettings.minimumApproachDistance.yards
                } set: { newValue in self.golfer.userDistanceSettings.minimumApproachDistance = .yards(newValue)
                },
            
            "Approach Proximity (ft)":
                Binding {
                    self.golfer.userDistanceSettings.averageProximity.yards
                } set: { newValue in self.golfer.userDistanceSettings.averageProximity = .yards(newValue)
                },
            
            "Chip Proximity (ft)":
                Binding {
                    self.golfer.userDistanceSettings.chipProximity.yards
                } set: { newValue in self.golfer.userDistanceSettings.chipProximity = .yards(newValue)
                },
        
        ]

    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(golfer: Golfer.golfer)
    }
}
