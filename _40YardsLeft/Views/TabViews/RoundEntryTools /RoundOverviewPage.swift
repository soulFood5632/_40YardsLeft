//
//  RoundOverviewPage.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-26.
//

import SwiftUI
import Charts
import FirebaseAuth

struct RoundOverviewPage: View {
    @Binding var golfer: Golfer
    @Binding var path: NavigationPath
    @Binding var showView: Bool
    let round: Round
    let isStat: Bool
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
                
                RoundStatOverview(round: self.round, isSnapshot: true)
                        .padding(.top, 3)
                
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
            
            if !isStat {
                Button {
                    Task {
                        golfer.addRound(self.round)
                        try await golfer.postToDatabase()
                    }
                    self.isRoundDone = true
                } label: {
                    
                    Label("Save Round", systemImage: "checkmark")
                    
                }
                .buttonStyle(.borderedProminent)
            }
            
            
            
        }
        .sheet(isPresented: self.$showStats, content: {
            GroupBox {
                RoundStatOverview(round: self.round, isSnapshot: false)
            } label: {
                Label("Stats", systemImage: "chart.bar")
            }
            .padding()
                
        })
        .toolbar {
            // TODO: rethink this structure to make editing possible.
            ToolbarItem (placement: .primaryAction) {
                Button {
                    self.showView = false
                    
                } label: {
                    Image(systemName: "pencil")
                }
            }
            
        }
        .onChange(of: self.isRoundDone, perform: { roundDone in
            // this section sends you back to the home page.
            if roundDone {
                self.path.keepFirst()
                self.showView = false
            }
            
        })
        .navigationBarBackButtonHidden()
        .padding()
    }
}

struct RoundOverviewPage_Previews: PreviewProvider {
    @State private static var golfer = Golfer.golfer
    @State private static var path = NavigationPath()
    @State private static var round = Round.completeRoundExample1
    @State private static var showView = true
    static var previews: some View {
        NavigationStack {
            RoundOverviewPage(golfer: $golfer, path: self.$path, showView: self.$showView, round: round, isStat: true)
        }
        
    }
}

//MARK: Round Stat Overview page.
struct RoundStatOverview : View {
    let round: Round
    @State var statFocus: AnalysisFocus = .approach
    
    let isSnapshot: Bool
    
    var shotList: [Shot] {
        round
            .holes
            .map { try! $0.getSimplifiedShots() }
            .flatten()
    }
    
    
    var body: some View {
        
        ScrollView {
            VStack {
                
                if (isSnapshot) {
                    
                    ScoreTypes(round: self.round)
                    
                    GreensFairwaysPutts(round: self.round)
                } else {
                    
                    
                    Picker(selection: $statFocus) {
                        ForEach(AnalysisFocus.allCases) { focus in
                            Text(focus.rawValue)
                        }
                    } label: {
                        // labels do nothing I do not get it.
                    }
                    .pickerStyle(.segmented)
                    
                    // never optional becuase and round on this page must be complete.
                    StrokesGainedGraph(
                        strokesGainedData: StrokesGainedData(shots: round
                            .holes
                            .map { try! $0.getSimplifiedShots() }
                            .flatten()),
                        focus: self.$statFocus
                    )
                    .padding()
                    
                    FocusedAnalysis(round: self.round, focus: self.statFocus)
                }
                
                 
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
        return self.getShots().filter(ShotFilters.allPutts).count
        
        //TODO: this is bugged.
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


