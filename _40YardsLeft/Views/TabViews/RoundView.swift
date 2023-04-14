//
//  RoundView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-24.
//

import SwiftUI

struct RoundView: View {
    @Binding var golfer: Golfer
    var body: some View {
        NavigationStack {
            Group {
                GroupBox {
                    GolferView(golfer: golfer)
                } label: {
                    Label("Overview", systemImage: "globe")
                }
                .frame(maxHeight: 200)
                GroupBox {
                    RoundViewList(golfer: $golfer)
                    
                } label: {
                    Label("History", systemImage: "list.bullet")
                    Divider()
                }
            }
            .padding(.horizontal)
            .navigationTitle("Rounds")
        }
    }
}

struct RoundView_Previews: PreviewProvider {
    
    @State private static var golfer = Golfer.golfer
    static var previews: some View {
        RoundView(golfer: $golfer)
    }
}
