//
//  RoundOverviewPage.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-26.
//

import SwiftUI
import FirebaseAuth

struct RoundOverviewPage: View {
    @Binding var golfer: Golfer
    @Binding var path: NavigationPath
    //TODO: investogate if binding is required here. 
    let round: Round
    @State private var isRoundDone = false
    @State private var showStats = false
    var body: some View {
        VStack {
            GroupBox {
                RoundDetailView(round: self.round)
                    .padding(.top, 3)
            } label: {
                Label("Round Details", systemImage: "folder")
            }
            
            GroupBox {
                ScorecardImage(round: round)
                    .padding(.top, 3)
            } label: {
                Label("Scorecard", systemImage: "square.grid.3x2")
            }
            
            GroupBox {
                
                RoundStatOverview(round: self.round)
                        .padding(.top, 3)
                        .onLongPressGesture {
                            //TODO: fix bug here.
                            self.showStats = true
                        }
                
            } label: {
                HStack {
                    Label("Stats", systemImage: "chart.bar")
                    Spacer()
                    Button {
                        self.showStats = true
                    } label: {
                        Image(systemName: "arrow.up.backward.and.arrow.down.forward")
                    }
                }
            }
            
            
            Button {
                Task {
                    //TODO: Update the golfer by adding the round.
                }
                self.isRoundDone = true
            } label: {
                
                Label("Save Round", systemImage: "checkmark")
 
            }
            .buttonStyle(.borderedProminent)
            //TODO: make navigation destination the home view.
            
            
            
        }
        .sheet(isPresented: self.$showStats, content: {
            GroupBox {
                RoundStatOverview(round: self.round)
            } label: {
                Label("Stats", systemImage: "chart.bar")
            }
            .padding()
                
        })
        .toolbar {
            ToolbarItem (placement: .primaryAction) {
                Button {
                    self.path.removeLast()
                } label: {
                    Image(systemName: "pencil")
                }
            }
            //TODO: add a delete round
        }
        .navigationBarBackButtonHidden()
        .padding()
    }
}

struct RoundOverviewPage_Previews: PreviewProvider {
    @State private static var golfer = Golfer.golfer
    @State private static var path = NavigationPath()
    @State private static var round = Round.completeRoundExample1
    static var previews: some View {
        NavigationStack {
            RoundOverviewPage(golfer: $golfer, path: self.$path, round: round)
        }
        
    }
}

struct RoundStatOverview : View {
    let round: Round
    
    
    var body: some View {
        
        ScrollView {
            VStack {
                Grid {
                    GridRow {
                        Group {
                            Text("Eagles+")
                            Text("Birdies")
                            Text("Pars")
                            Text("Bogeys")
                            Text("Doubles+")
                        }
                        .font(.headline)
                    }
                    
                    Divider()
                    
                    GridRow {
                        Text(round.eaglesOrBetter, format: .number)
                        Text(round.birdies, format: .number)
                        Text(round.pars, format: .number)
                        Text(round.bogeys, format: .number)
                        Text(round.doubleBogeysOrWorse, format: .number)
                    }
                }
                
                HStack {
                    GroupBox {
                        VStack {
                            let greenPercentage = Double(round.getGreens().0) / Double(round.getGreens().1)
                            Text("\(round.getGreens().0) | " + greenPercentage.roundToPercent())
                            
                            Text("Greens")
                                .font(.headline)
                        }
                        
                    }
                    
                    
                    GroupBox {
                        VStack {
                            Text("\(round.putts())")
                            
                            Text("Putts")
                                .font(.headline)
                        }
                    }
                    GroupBox {
                        let fairwayPercentage = Double(round.fairways().0) / Double(round.fairways().1)
                        Text("\(round.fairways().0) | " + fairwayPercentage.roundToPercent())
                        Text("Fairways")
                            .font(.headline)
                        
                    }
                    
                }
                
                Grid {
                    GridRow {
                        Group {
                            Text("Tee")
                            Text("Approach")
                            Text("Chip")
                            Text("Putt")
                        }
                        .font(.headline)
                    }
                    
                    Divider()
                    
                    GridRow {
                        //TODO: complete trokes gained
                        Text(0.01, format: .number)
                        Text(-1.7, format: .number)
                        Text(1.4, format: .number)
                        Text(-2.9, format: .number)
                        
                    }
                }
                
                //TODO: Complete more of these. 
            }

        }
        
    }
}

struct RoundDetailView: View {
    let round: Round
    var body: some View {
        HStack (alignment: .top) {
            VStack (alignment: .leading) {
                Text(round.course.name)
                    .bold()
                    .font(.headline)
                
                Text(round.course.location.addressLine1)
                    .font(.subheadline)
                
                Text(round.course.location.city + ", " + round.course.location.province.rawValue)
                    .font(.subheadline)
            }
            Spacer()
            
            VStack (alignment: .trailing) {
                Text(round.tee.name)
                    .font(.headline)
                    .bold()
                
                Text("\(round.tee.yardage.yards, format: .number)")
                
                Text("\(round.tee.slope) | \(round.tee.rating, format: .number)")
                
            }
        }
        
    }
}

extension Round {
    var eaglesOrBetter: Int {
        return self.countOfHolesThatMatchScoreToPar(range: .min...(-2))
    }
    
    var birdies: Int {
        return self.countOfHolesThatMatchScoreToPar(value: -1)
    }
    
    var pars: Int {
        return self.countOfHolesThatMatchScoreToPar(value: 0)
    }
    
    var bogeys: Int {
        return self.countOfHolesThatMatchScoreToPar(value: 1)
    }
    
    var doubleBogeysOrWorse: Int {
        return self.countOfHolesThatMatchScoreToPar(range: 2...Int.max)
    }
    
    private func countOfHolesThatMatchScoreToPar(value: Int) -> Int {
        return self.holes.filter { $0.isComplete }.filter { $0.scoreToPar == value }.count
    }
    
    private func countOfHolesThatMatchScoreToPar(range: ClosedRange<Int>) -> Int {
        return self.holes.filter { $0.isComplete }.filter { range.contains($0.scoreToPar) }.count
    }
    
    
    /// Gets the number greens hit in the round.
    ///
    /// - Returns: A tuple containg the number of greens hit as the first entry, and the number of oppuritinites as the second entry.
    func getGreens() -> (Int, Int) {
        self.holes.map  { $0.greenInReg }.reduce((0, 0)) { intermediate, green in
            return (green ? intermediate.0 + 1 : intermediate.0, intermediate.1 + 1)
        }
    }
    
    /// The number of putts in this round
    ///
    /// - Returns: The number of putts in the given round.
    func putts() -> Int {
        return self.getShots().filter { $0.type == .putt }.count
    }
    
    
    /// Gets the number of fairways hit in this round
    /// 
    /// - Returns: A tuple containg the number of fairways hit in the first entry and the number of oppurinties in the second one.
    func fairways() -> (Int, Int) {
        return self.holes.map{ $0.fairway }.filter { $0 != nil }.reduce((0, 0)) { partialResult, fairway in
            // we can force unwrap the fairway object becuase we have filtered out nils
            return (fairway! ? partialResult.0 + 1 : partialResult.0, partialResult.1 + 1)
        }
    }
}


