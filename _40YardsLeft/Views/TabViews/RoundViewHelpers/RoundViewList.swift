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
    @State var highlightedRound: Round?
    
    @State private var roundToDelete: Round?
    var body: some View {
        
        if golfer.rounds.isEmpty {
            VStack {
                Text("You haven't posted a round yet")
                    .bold()
                    .padding(.bottom, 1)
                Button {
                    withAnimation {
                        path.keepFirst()
                        path.append(ScreenState.play)
                    }
                } label: {
                    Text("Start Your First Round")
                }
            }
            
        } else {
            
            Grid {
                ForEach(golfer.rounds) { round in
                    GridRow {
                        HStack {
                            Text(String(round.roundScore))
                                .bold()
                            
                            Text("\(round.course.name)")
                            
                            Spacer()
                            
                            
                            let roundBinding = Binding {
                                self.roundToDelete != nil
                            } set: { valueBinding in
                                self.roundToDelete = nil
                            }
                            
                            Button (role: .destructive) {
                                self.roundToDelete = round
                            } label: {
                                Image(systemName: "trash")
                            }
                            .confirmationDialog("Delete Round", isPresented: roundBinding) {
                                Button("Delete Round") {
                                    self.golfer.deleteRound(round)
                                    Task {
                                        try await self.golfer.postToDatabase()
                                    }
                                }
                            }
                            
                            Button {
                                self.highlightedRound = round
                                
                                self.showSpecificRoundView = true
                            
                            } label: {
                                Image(systemName: "info.circle")
                            }

                        }
                        
                    }
                    .padding(.top, 1)
                }
            }
            .sheet(isPresented: self.$showSpecificRoundView, content: {
                RoundOverviewPage(golfer: self.$golfer, path: self.$path, showView: self.$showSpecificRoundView, round: self.highlightedRound!)
            })
            .animation(.easeInOut, value: self.golfer.rounds)
            
        }
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
