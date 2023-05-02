//
//  RoundEntry.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-28.
//

import SwiftUI



struct RoundEntry: View {
    
    @Binding var golfer: Golfer
    
    @State private var round: Round?
    
    @State private var course: Course?
    
    @State private var newCourse = false
    
    @State private var startRound = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Group {
                    GroupBox {
                        PickACourse(course: self.$course)
                    } label: {
                        Label("Choose Course", systemImage: "list.bullet.clipboard")
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
            }
            
        }
        .onAppear {
            // I think we want to reset the cours when this view is opened
            self.course = nil
        }
        .navigationTitle("Course Selection")
        .navigationDestination(isPresented: self.$startRound) {
            if course != nil {
                
                let unwrappedBinding = Binding<Course> {
                    return self.course!
                } set: { newValue in
                    self.course = newValue
                }
                
                RoundSetupView(course: unwrappedBinding, round: self.$round, golfer: self.$golfer)
            }
        }
        .onChange(of: self.course, perform: { newCourse in
            if newCourse != nil {
                self.startRound = true
            }
        })
        .navigationTitle("Course Selection")
        .sheet(isPresented: self.$newCourse) {
            CreateCourse(course: self.$course, showView: self.$newCourse)
            
            
        }
    }
}

struct RoundEntry_Previews: PreviewProvider {
    @State private static var golfer = Golfer.golfer
    static var previews: some View {
        RoundEntry(golfer: self.$golfer)
    }
}
