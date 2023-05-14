//
//  HoleByHole.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-28.
//

import SwiftUI

/// <#Description#>
struct HoleByHole: View {
    @Binding var golfer: Golfer
    @State var round: Round
    @Binding var path: NavigationPath
    
    private let shotPredictor = ShotPredictor()
    @State var holeNumber: Int
    @State private var isHoleSaved: [Bool] = .init(repeating: false, count: 18)
    
    @State private var isDeleteRound = false
    @State private var isRoundSetup = false

    
    /// A state variable which holds a map to each shotIntermediate for each hole in the round
    @State private var shotList: [[ShotIntermediate]] = .init(repeating: [], count: 18)
    
    @State private var showScorecard = false
    
    @ViewBuilder
    var holeInfo: some View {
        let hole = round.tee.holeData[holeNumber - 1]
        HStack {
            Text("Par \(hole.par)")
            
            Divider()
            
            
            
            Text("\(hole.yardage.yards, format: .number) Yards")
            //TODO: fix this to a dependency on the settings if this application.
            
            Divider()
            
            Text("Hcp: \(hole.handicap)")
        }
    }
    
    
    var body: some View {
    
        
            VStack {
                Text("Hole \(holeNumber)")
                    .bold()
                    .font(.title)
                
                Divider()
                
                holeInfo
                    .frame(maxHeight: 50)
                
                
                    GroupBox {
                        VStack {
                            Grid(alignment: . center) {
                                GridRow {
                                    Text("To Hole")
                                    Text("Lie")
                                    Text("Type")
                                }
                                .bold()
                                Divider()


                                    ForEach($shotList[self.holeNumber - 1]) { shot in
                                        GridRow {
                                            ShotElement(shot: shot, isFinal: self.$isHoleSaved[holeNumber - 1])
                                        }
                                    }
                                    .onDelete { indexSet in

                                        indexSet.forEach { index in
                                            shotList[self.holeNumber - 1].remove(at: index)
                                        }
                                    }

                            }
                            Button {
                                self.addNextValueTo(holeNumber: holeNumber)
                            } label: {
                                Spacer()
                                Label("Add Shot", systemImage: "plus.circle")
                                    .bold()
                                Spacer()
                            }
                            .disabled(self.isHoleSaved[holeNumber - 1])
                            .padding(.top, 1)


                        }
                        .padding(.vertical, 3)
                        
                    } label: {
                        HStack {
                            Label("Shot Entry", systemImage: "figure.golf")

                            Spacer()

                            if
                                !shotList[holeNumber - 1].isEmpty {
                                if isHoleSaved[holeNumber - 1] {
                                    Button {
                                        isHoleSaved[holeNumber - 1] = false
                                    } label: {
                                        Image(systemName: "pencil")
                                    }
                                } else {
                                    Button {
                                        isHoleSaved[holeNumber - 1] = true
                                    } label: {
                                        Image(systemName: "checkmark")
                                    }
                                    .disabled(shotList[holeNumber - 1].isEmpty)
                                }

                                Button(role: .destructive) {
                                    self.shotList[holeNumber - 1].removeAll()
                                    self.isHoleSaved[holeNumber - 1] = false
                                } label: {
                                    Image(systemName: "arrow.counterclockwise")
                                }
                                .padding(.leading, 7)
                                .disabled(shotList[holeNumber - 1].isEmpty)

                            }
                        }
                    }
                    .padding()
                    
                Spacer()
                
                Button {
                    //TODO: finish the round and send the user to the overview page.
                    
                    // Do note the bug where this view cannot house and navigation destinations. 
                } label: {
                    Label("Finish Round", systemImage: "checkmark")
                }
                .buttonStyle(.bordered)
                .disabled(!self.round.isComplete)
                 

            }
            .animation(.easeInOut, value: self.shotList[holeNumber - 1])
            .animation(.easeInOut, value: self.isHoleSaved[holeNumber - 1])
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {


                    Button(role: .destructive) {
                        self.isDeleteRound = true
                    } label: {
                        Image(systemName: "trash")
                    }
                    .confirmationDialog("Cancel Round", isPresented: self.$isDeleteRound, actions: {
                        Button(role: .destructive) {
                            self.path.keepFirst()
                        } label: {
                            Text("Confirm")
                        }

                        Button {
                            //no action
                        } label: {
                            Text("Cancel")
                        }


                    }, message: {
                        Text("Your scores will be deleted")
                    })


                }
                
                ToolbarItem(placement: .navigation) {
                    Button(role: .cancel) {
                        self.isRoundSetup = true
                    } label: {
                        Text("Change Tee")
                    }
                    .confirmationDialog("", isPresented: self.$isRoundSetup, actions: {
                        Button(role: .destructive) {
                            self.path.removeLast()
                        } label: {
                            Text("Confirm")
                        }

                        Button {
                            //no action
                        } label: {
                            Text("Cancel")
                        }


                    }, message: {
                        Text("Your scores will be deleted")
                    })
                }
                
                
        
                
                ToolbarItemGroup(placement: .bottomBar) {

                    if holeNumber > 1 {
                        Button {
                            self.holeNumber -= 1

                        } label: {
                            Label("Last Hole", systemImage: "arrow.backward.circle")
                        }

                    }

                    Spacer()



                    Spacer()
                    if holeNumber < 18 {
                        Button {
                            self.holeNumber += 1
                        } label: {
                            Label("Next Hole", systemImage: "arrow.forward.circle")
                        }
                    }
                }
                
                
                ToolbarItem (placement: .navigationBarTrailing) {
                    Button {
                        self.showScorecard = true
                    } label: {
                        Label("Scorecard", systemImage: "tablecells")
                    }
                }
            }
            .sheet(isPresented: self.$showScorecard, content: {
                ScorecardView(round: self.round, currentHole: self.$holeNumber, showView: self.$showScorecard)

            })
            .navigationBarBackButtonHidden()
            .onChange(of: self.holeNumber, perform: { [holeNumber] newValue in
                
                Task {
                    await self.postShots(for: holeNumber)

                }
                
            })
            .onAppear {
               
                for index in self.shotList.indices {
                    self.shotList[index].append(getNextValue(holeNumber: index + 1))
                }
            }

        
    }
}

extension HoleByHole {
    
    private func addNextValueTo(holeNumber: Int) {
        
        self.shotList[holeNumber - 1].append(getNextValue(holeNumber: holeNumber))
        
    }
    
    private func getNextValue(holeNumber: Int) -> ShotIntermediate {
        if let lastPosition = self.shotList[holeNumber - 1].last?.position {
            
            let suggestedPosition = shotPredictor.predictedNextLocation(lastPosition, par: round.tee.holeData[holeNumber - 1].par)
            
            return .init(position: suggestedPosition, declaration: suggestedPosition.expectedShotType())
        }
        
        return round.holes[holeNumber - 1].getFirstShotPredictor()
    }
    
    
    /// Posts the shot intermediates for the given hole to the round.
    ///
    /// Calling this function will overwrite the current values in the shots for that particular hole in the round.
    ///
    /// - Parameter hole: <#hole description#>
    private func postShots(for hole: Int) async {
        let intermediatesList = self.shotList[hole - 1]
        var index = 0
        var shotList = [Shot]()
        
        //below we enter the loop that fills the shots with their entries from the shot Intermidates.
        while index < intermediatesList.count {
            
            if index != 0 {
                let pos1 = intermediatesList[index - 1]
                
                let pos2 =  intermediatesList[index]
                shotList.append(Shot(type: pos1.type, startPosition: pos1.position, endPosition: pos2.position))
            }
            index += 1
        }
        // adds the last shot that holes out the shot
        if let intermediate = intermediatesList.last {
            shotList.append(.init(type: intermediate.type, startPosition: intermediate.position, endPosition: .holed))
        }
        
        let boolArray = self.round.updateHole(hole, with: shotList)
        
        
    }
}

//MARK: Preciew
struct HoleByHole_Previews: PreviewProvider {
    @State static private var holeNumber = 1
    @State private static var round = Round.emptyRoundExample1
    @State private static var golfer = Golfer.golfer
    @State private static var path = NavigationPath()
    static var previews: some View {
        NavigationStack {
            HoleByHole(golfer: $golfer, round: round, path: self.$path, holeNumber: holeNumber)
        }
    }
}

struct ShotIntermediate : Identifiable, Equatable {
    let id: UUID = UUID()
    var position: Position
    var declaration: ShotDeclaration
    
    var type: ShotType {
        switch declaration {
        case .drive:
            return .drive
            
        case .atHole:
            switch position.lie {
            case .fairway, .bunker, .rough, .recovery, .tee:
                if position.yardage.yards > 50 {
                    return .approach
                }
                return .chip_pitch
                
            case .green:
                return .putt
                
            case .penalty:
                fatalError("You cannot go towards the hole if you are in a penatly area")
            }
        case .drop:
            return .penalty
        case .other:
            return .other
        
        }
    }
    
    enum ShotDeclaration: String, CaseIterable, Identifiable {
        
        case drive = "Drive"
        case atHole = "At Hole"
        case other = "Other"
        case drop = "Drop"
        
        var id: Self { self }
    }
    
}


extension Hole {
    func getFirstShotPredictor() -> ShotIntermediate {
        return .init(position: Position(lie: .tee, yardage: self.holeData.yardage),
                     declaration: self.holeData.par == 3 ? .atHole : .drive)
    }
}

struct NavigationStackRound: Hashable {
    let isFinal: Bool
    var round: Round
    
    init(round: Round) {
        self.isFinal = true
        self.round = round
    }

}


