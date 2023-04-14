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
                        Divider()
                        Text("\(round.course.name)")
                            
                        
                        
                        Text("\(round.course.name)")
                        
                        Menu {
                            
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                        
                        NavigationLink {
                            HoleByHole(round: round, holeNumber: 1)
                        } label: {
                            Image(systemName: "pencil")
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
                                Button("OK") {
                                    //delete round
                                }
                                Button("Cancel") {
                                    // no action
                                }
                            }
                        
                    }

                }
            }
        }
    }
}

extension RoundViewList {
    
}

struct RoundViewList_Previews: PreviewProvider {
    @State private static var golfer = Golfer.golfer
    static var previews: some View {
        RoundViewList(golfer: self.$golfer)
    }
}
