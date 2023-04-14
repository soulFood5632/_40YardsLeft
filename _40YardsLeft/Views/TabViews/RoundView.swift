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
            GroupBox {
                RoundViewList(golfer: $golfer)
                    
            } label: {
                Text("History")
            }
            .padding(.horizontal)
            .navigationTitle("Round History")
        }
    }
}

struct RoundView_Previews: PreviewProvider {
    
    @State private static var golfer = Golfer.golfer
    static var previews: some View {
        RoundView(golfer: $golfer)
    }
}
