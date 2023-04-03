//
//  HoleByHole.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-28.
//

import SwiftUI

/// <#Description#>
struct HoleByHole: View {
    @State var round: Round
    @State var holeNumber: Int {
        // a task to complete prior to the update of the holeNumber
        willSet {
            Task {
                await self.postShots(for: self.holeNumber)
            }
        }
    }

    
    /// A state variable which holds a map to each shotIntermediate for each hole in the round
    @State private var shotList: [[ShotIntermediate]] = {
        //TODO: fix this so it matches the number of holes which are being played.
        var map = [[ShotIntermediate]]()
        for _ in 1...18 {
            map.append([ShotIntermediate]())
        }
        return map
    }()
    
    @State private var showScorecard = false
    
    var body: some View {
        NavigationStack {
            let hole = round.tee.holeData[holeNumber - 1]
            VStack {
                Text("Hole \(holeNumber)")
                    .bold()
                    .font(.title)
                
                Divider()
                
                HStack {
                    Text("Par \(hole.par)")
                    
                    Divider()
                    
                    
                    
                    Text("\(hole.yardage.yardage, specifier: "%.0f") Yards")
                    //TODO: fix this to a dependency on the settings if this application.
                    
                    Divider()
                    
                    Text("Hcp: \(hole.handicap)")
                }
                .frame(maxHeight: 50)
                
                VStack {
                    List {
                        Section {
                            HStack {
                                Text("Yardage")
                                 Spacer()
                                Text("Lie")
                                Spacer()
                                
                                Text("Shot Type")
                            }
                            .bold()
                            ForEach($shotList[self.holeNumber - 1]) { shot in
                                ShotElement(shot: shot)
                            }
                            
                            Button {
                                //TODO: make this a suggested value
                                self.shotList[holeNumber - 1].append(ShotIntermediate(position: Position(lie: .fairway, yardage: Distance(yards: 100)), type: .approach))
                            } label: {
                                Label {
                                    Text("Add shot")
                                } icon: {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.green)
                                }
                                
                            }
                        } header: {
                            Label("Shot Entry", systemImage: "figure.golf")
                        }
                        
                        //TODO: make editable list in the style of the new item with a green plus. It should include the option for drag and drops, and the ability to slide to delete
                    }
                }
                    

            }
            .toolbar {
                ToolbarItem (placement: .primaryAction) {
                    if holeNumber == 18 {
                        NavigationLink {
                            EmptyView()
                            //TODO: add round overview page
                        } label: {
                            Label("Finish Round", systemImage: "checkmark")
                        }
                        
                    } else {
                        Button {
                            self.holeNumber += 1
                        } label: {
                            Label("Next Hole", systemImage: "arrow.forward.circle")
                        }
                    }

                }
                
                ToolbarItem (placement: .secondaryAction) {
                    if holeNumber > 1 {
                        Button {
                            self.holeNumber -= 1
                        
                        } label: {
                            Label("Last Hole", systemImage: "arrow.backward.circle")
                        }

                    }
                }
                
                ToolbarItem (placement: .bottomBar) {
                    Button {
                        self.showScorecard = true
                    } label: {
                        Label("Scorecard", systemImage: "tablecells")
                    }

                }
            }
            .sheet(isPresented: self.$showScorecard, content: {
                ScorecardView(round: self.round, currentHole: self.$holeNumber)
                //TODO: mayeb add a showView so it knows when to drop its gaurd after a new hole has been selected
            })
            .navigationTitle("Score Entry")
            .onAppear {
                let startPosition = Position(lie: .tee,
                                             yardage: hole.yardage)
                //TODO: Imploment the autofill function here
                
                Task {
                    //adds this course to the database
                    try await DatabaseCommunicator.addCourse(course: self.round.course)
                }
            }

    
                
            
        }
    }
}

extension HoleByHole {
    
    private func postShots(for hole: Int) async {
        var intermediatesList = self.shotList[hole - 1]
        var index = 0
        var shotList = [Shot]()
        
        //below we enter the loop that fills the shots with their entries from the shot Intermidates.
        while index < intermediatesList.count {
            
            if index != 0 {
                let pos1 = intermediatesList[index - 1]
                let pos2 = intermediatesList[index]
                shotList.append(Shot(type: pos1.type, startPosition: pos1.position, endPosition: pos2.position))
            }
            index += 1
        }
        
        self.round.holes[hole - 1].shots = shotList
    }
}

struct HoleByHole_Previews: PreviewProvider {
    @State static private var holeNumber = 1
    @State private static var round = Round.example1
    static var previews: some View {
        HoleByHole(round: round, holeNumber: holeNumber)
    }
}

struct ShotIntermediate : Identifiable {
    let id: UUID = UUID()
    var position: Position
    var type: ShotType
}
