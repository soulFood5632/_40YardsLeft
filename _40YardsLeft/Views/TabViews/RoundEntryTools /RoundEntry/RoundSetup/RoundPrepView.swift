//
//  RoundPrepView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-01.
//

import SwiftUI

//MARK: Round Setup Buffer
struct RoundSetupBuffer {
    var tee: Tee?
    var date: Date = .now
    var roundType: RoundType = .casual
    //TODO: add the ability to change rountype
    
    
    /// Creates a round from the provided tee buffer.
    ///
    /// - Requires: The tee in this buffer is not nil.
    ///
    /// - Requires: The tee is valid and is one of the tees on the provided course.
    ///
    /// - Parameter course: The course in which this round will be created on.
    /// - Returns: A round contaning the provided inforamtion in the buffer.
    func createRound(course: Course) -> Round {
        precondition(tee != nil)
        // there should be now way
        return try! Round(course: course, tee: self.tee!, date: self.date, roundType: roundType)
    }
    
}



//MARK: Round Prep View
struct RoundPrepView: View {
    @Binding var round: Round?
    @Binding var course: Course
    @Binding var golfer: Golfer
    
    @State private var buffer = RoundSetupBuffer()
    
    @State private var isCreateNewTee = false

    var body: some View {
        
        VStack {
            GroupBox {
                List {
                    ForEach(course.listOfTees) { tee in
                        let isHighlighted = self.buffer.tee == tee
                        HStack {
                            Text("\(tee.name)")
                                .bold()
                            Divider()
                            Text("\(tee.rating, format: .number) | \(tee.slope) | \(tee.yardage.yards, format: .number) | \(tee.par)")
                            
                            if isHighlighted {
                                Image(systemName: "checkmark")
                            }
                            
                        }
                        .onTapGesture {
                            if isHighlighted {
                                self.buffer.tee = nil
                            } else {
                                self.buffer.tee = tee
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
                    
                    DatePicker(selection: self.$buffer.date) {
                        Image(systemName: "calendar.badge.clock")
                    }
                    .datePickerStyle(.compact)
                    .frame(alignment: .center)
                    HStack {
                        
                        PickerAndLabel(pickedElement: self.$buffer.roundType, choices: RoundType.allCases, title: "Round Type")
                            .pickerStyle(.wheel)
                    }
                }
            } label: {
                Label("Other Info", systemImage: "info.circle")
            }
            
            
            
            
            NavigationLink {
                //Create the new round when this button is pressed.
                if self.isReady {
                    let round = self.buffer.createRound(course: self.course)
                    
                    HoleByHole(golfer: self.$golfer, round: round, holeNumber: 1)
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
        .onDisappear {
            //TODO: Think about how we can handle these errors in a better way.
            
            //TODO: note that this view will only dissapear when a round is started. Investigate whether a flag here would be a better idea. 
            Task {
                try await DatabaseCommunicator.addCourse(course: self.course)
            }
        }
    }
    
}

//MARK: Round Prep Helpers
extension RoundPrepView {
    private var hasTees: Bool {
        return !course.listOfTees.isEmpty
    }
    
    private var isReady: Bool {
        //TODO: fill this out with new conditions
        return self.buffer.tee != nil
    }
}

struct RoundPrepView_Previews: PreviewProvider {
    @State private static var course = Course.example1
    @State private static var round: Round?
    @State private static var golfer = Golfer.golfer
    static var previews: some View {
        RoundPrepView(round: self.$round, course: self.$course, golfer: self.$golfer)
    }
}
