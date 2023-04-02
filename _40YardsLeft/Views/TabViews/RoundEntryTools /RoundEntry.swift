//
//  RoundEntry.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-28.
//

import SwiftUI



struct RoundEntry: View {
    
    @State private var round: Round?
    
    @State private var course: Course?
    
    @State private var newCourse = false
    
    var body: some View {
        NavigationView {
            VStack {
                if course == nil {
                    Group {
                        GroupBox {
                            PickACourse()
                        } label: {
                            Label("Pick From Previous", systemImage: "list.bullet.clipboard")
                        }
                        
                        HStack {
                            Text("OR")
                                .font(.title3)
                                .bold()
                        }
                        
                        GroupBox {
                            Button {
                                self.newCourse = true
                            } label: {
                                Text("Create Course")
                            }
                            .buttonStyle(.borderedProminent)
                        } label: {
                            Label("New Course", systemImage: "pencil")
                        }
                    }
                    .padding(.horizontal)
                } else {
                    
                    GroupBox {
                        let unwrappedBinding = Binding<Course> {
                            return self.course!
                        } set: { newValue in
                            self.course = newValue
                        }
                        
                        
                        
                        RoundPrepView(round: self.$round, course: unwrappedBinding)
                    } label: {
                        Label("Setup Round", systemImage: "slider.horizontal.3")
                    }
                }
                
                
                

            }
            .navigationTitle("Round Entry")
            .sheet(isPresented: self.$newCourse) {
                // TODO: add on dismiss functionaility, like populate the optional course with the new value
            } content: {
                CreateCourse(course: self.$course, showView: self.$newCourse)
            }

        }
    }
}

struct RoundEntry_Previews: PreviewProvider {
    static var previews: some View {
        RoundEntry()
    }
}
