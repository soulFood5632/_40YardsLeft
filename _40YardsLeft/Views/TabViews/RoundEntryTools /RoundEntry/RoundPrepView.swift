//
//  RoundPrepView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-01.
//

import SwiftUI

struct RoundSetupBuffer {
    var tee: Tee?
    var date: Date = .now
}

struct RoundPrepView: View {
    @Binding var round: Round?
    @Binding var course: Course
    
    @State private var tee: Tee?
    @State private var date = Date.now
    
    @State private var isCreateNewTee = false

    var body: some View {
        NavigationStack {
            VStack {
                if tee != nil {
                    //at this point in the flow the tee has be non-nil becuase of the onChange function
                    
                    let teeBinding = Binding {
                        self.tee!
                    } set: { newTee in
                        self.tee = newTee
                    }
                    
                    Picker(selection: teeBinding) {
                        ForEach(self.course.listOfTees) { tee in
                            HStack {
                                Text(tee.name)
                                Text(tee.rating.toDecimalPlaces(1))
                                Text(tee.slope.formatted())
                                
                            }
                        }
                    } label: {
                        //empty label
                    }
                    
                    Text("OR")
                    
                }
                
                Button {
                    self.isCreateNewTee = true
                } label: {
                    Text("Add Tee")
                }
                .buttonStyle(.borderedProminent)
                
                
                
                DatePicker(selection: self.$date) {
                    //empty label
                }
                
                
                
                
                NavigationLink {
                    // tee can be safely unwrapped here bc the button is disabled when the value is nil.
                    if let round = self.round {
                        HoleByHole(round: round, holeNumber: 1)
                        
                        
                    }
                    
                } label: {
                    Label("Start Round", systemImage: "figure.golf")
                }
                
                
                .buttonStyle(.borderedProminent)
                .disabled(self.round == nil)
                
            }
            .onChange(of: hasTees, perform: { newValue in
                if newValue {
                    self.tee = course.listOfTees.randomElement()!
                }
            })
            .onChange(of: self.tee, perform: { newTee in
                if let newTee {
                    do {
                        self.round = try Round(course: self.course, tee: newTee)
                        
                        
                    } catch {
                        //unreachable line of code becuase the UI should not allow the possibility for breaking of conditions.
                        fatalError("User should not be able to select a tee which does not exist")
                    }
                }
            })
            .sheet(isPresented: self.$isCreateNewTee) {
                CourseHoleByHole(course: self.$course, showView: self.$isCreateNewTee)
                    .padding()
            }
        }
    }
}

extension RoundPrepView {
    private var hasTees: Bool {
        return !course.listOfTees.isEmpty
    }
}

struct RoundPrepView_Previews: PreviewProvider {
    @State private static var course = Course.example1
    @State private static var round: Round?
    static var previews: some View {
        RoundPrepView(round: self.$round, course: self.$course)
    }
}
