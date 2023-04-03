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
                GroupBox {
                    List {
                        ForEach(course.listOfTees) { tee in
                            let isHighlighted = self.tee == tee
                            HStack {
                                Text("\(tee.name)")
                                    .bold()
                                Divider()
                                Text("\(tee.rating, format: .number) | \(tee.slope) | \(tee.yardage) | \(tee.par)")
                                
                                if isHighlighted {
                                    Image(systemName: "checkmark")
                                }
                                
                            }
                            .onTapGesture {
                                if isHighlighted {
                                    self.tee = nil
                                } else {
                                    self.tee = tee
                                }
                            }
                            .foregroundColor(isHighlighted ? .primary : .secondary)
                            
                            
                            
                        }
                        
                        Button {
                            // signals the addition of a new tee via the sheet
                            self.isCreateNewTee = true
                        } label: {
                            Label("Add Tee", systemImage: "plus")
                        }
                        
                        
                        
                    }
                } label: {
                    Label("Choose Tee", systemImage: "dots.and.line.vertical.and.cursorarrow.rectangle")
                }
                    
                    
                    
                    
                    
                GroupBox {

                    
                    Form {
                        
                        DatePicker(selection: self.$date) {
                            Image(systemName: "calendar.badge.clock")
                        }
                        .datePickerStyle(.compact)
                        .frame(alignment: .center)
                        
                        //TODO: Add wheather details and round type
                    }
                } label: {
                    Label("Other Info", systemImage: "info.circle")
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
                .disabled(!self.isReady)
                
            }
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
    
    private var isReady: Bool {
        //TODO: fill this oput with new conditions
        return self.tee != nil
            
        
    }
}

struct RoundPrepView_Previews: PreviewProvider {
    @State private static var course = Course.example1
    @State private static var round: Round?
    static var previews: some View {
        RoundPrepView(round: self.$round, course: self.$course)
    }
}
