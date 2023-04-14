//
//  SwiftUIView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-13.
//

import SwiftUI

struct RoundViewList: View {
    @Binding var golfer: Golfer
    
    @State private var roundToDelete: Round?
    var body: some View {
        
            
        Grid {
            
            ForEach(golfer.rounds) { round in
                GridRow {
                    HStack {
                        Text(String(round.roundScore))
                            .bold()
                        
                        Text("\(round.course.name)")
                            
                        Spacer()
                        
                            //TODO: think of a better to explore more info
                        Menu {
                            RoundInfo(round: round)
                        } label: {
                            Image(systemName: "info.circle")
                        }
                        
                        
                        
                        let roundBinding = Binding {
                            self.roundToDelete != nil
                        } set: { valueBinding in
                            self.roundToDelete = nil
                        }
                        
                        
                            

                        
                        Image(systemName: "trash")
                            .onTapGesture {
                                self.roundToDelete = round
                            }
                            .confirmationDialog("Delete Round", isPresented: roundBinding) {
                                Button("Delete Round") {
                                    self.golfer.deleteRound(round)
                                }
                            }
                            .foregroundColor(.red)
                        
                        NavigationLink {
                            HoleByHole(round: round, holeNumber: 1)
                        } label: {
                            Image(systemName: "pencil")
                        }
                        
                    }

                }
            }
        }
        .animation(.easeInOut, value: self.golfer.rounds)
        .frame(width: .infinity)
    }
}

extension RoundViewList {
    
}

struct RoundViewList_Previews: PreviewProvider {
    @State private static var golfer = Golfer.golfer
    static var previews: some View {
        NavigationStack {
            RoundViewList(golfer: self.$golfer)
        }
    }
}
