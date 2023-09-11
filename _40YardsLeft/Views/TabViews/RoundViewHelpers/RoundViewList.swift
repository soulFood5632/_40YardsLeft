//
//  SwiftUIView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-13.
//

import SwiftUI

struct RoundViewList: View {
    @Binding var golfer: Golfer
    @Binding var path: NavigationPath
    @State var showSpecificRoundView: Bool = false
    @State private var highlightedRound: Round = Round.completeRoundExample1
    
    @State private var selectedRounds = [Round]()
    @State private var showStats = false
    
    
    var body: some View {
        
        
        
        VStack {
            
            List (golfer.roundsSortedByDate) { round in
                
                HStack {
                    
                    Group {
                        Text(String(round.roundScore))
                            .font(.system(size: 15))
                            .bold()
                        
                        VStack (alignment: .leading) {
                            Text("\(round.course.name)")
                                .font(.system(size: 13))
                            Text(round.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.system(size: 8))
                                .fontWeight(.light)
                        }
                    }
                    .onTapGesture {
                        if selectedRounds.contains(round) {
                            selectedRounds.removeAll(where: { $0 == round })
                        } else {
                            selectedRounds.append(round)
                        }
                    }
                    .foregroundColor(selectedRounds.contains(round) ? .accentColor : .primary)
                    .bold(selectedRounds.contains(round))
                    
                    Spacer()
                    
                    Menu {
                        
                        
                        Button (role: .destructive) {
                            self.golfer.deleteRound(round)
                            Task {
                                try await self.golfer.postToDatabase()
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                        Button {
                            self.highlightedRound = round
                            
                            print(round.id)
                        } label: {
                            Label("Info", systemImage: "info.circle")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                    
                }
                
            }
            .onChange(of: self.highlightedRound, perform: { _ in
                showSpecificRoundView = true
            })
            .sheet(isPresented: self.$showSpecificRoundView, content: {
                
                RoundOverviewPage(golfer: self.$golfer, path: self.$path, showView: self.$showSpecificRoundView, round: self.highlightedRound)
                
                    
            })
            
            if !selectedRounds.isEmpty {
                Button {
                    showStats = true
                } label: {
                    Label("Analyze Rounds", systemImage: "chart.bar")
                }
            }
        }
        .sheet(isPresented: self.$showStats, content: {
            StatAnalysisView(rounds: self.selectedRounds)
        })
        .animation(.easeInOut, value: self.golfer.rounds)
        .animation(.easeInOut, value: self.selectedRounds)

    }
}



struct RoundViewList_Previews: PreviewProvider {
    @State private static var golfer = Golfer.golfer
    @State private static var path = NavigationPath()
    static var previews: some View {
        NavigationStack {
            RoundViewList(golfer: self.$golfer, path: $path)
        }
    }
}
