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
                            
                            
                            //TODO: fix this link
                            NavigationLink {
                                HoleByHole(golfer: self.$golfer, round: round, path: self.$path, holeNumber: 1)
                            } label: {
                                Image(systemName: "pencil")
                            }
                            
                            
                            
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
                                }
                            }
                            
                            
                                                            
                            //TODO: think of a better to explore more info
                            Menu {
                                RoundInfo(round: round)
                            } label: {
                                Image(systemName: "info.circle")
                            }
                            
                            
                            
                        }
                        
                    }
                }
            }
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
