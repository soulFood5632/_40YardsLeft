//
//  RoundView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-24.
//

import SwiftUI

struct RoundView: View {
    @Binding var golfer: Golfer
    @Binding var path: NavigationPath
    var body: some View {
        
        VStack {
        
            Group {
                GroupBox {
                    GolferView(golfer: golfer)
                } label: {
                    Label("Overview", systemImage: "globe")
                }
                .frame(maxHeight: 200)
                GroupBox {
                    RoundViewList(golfer: $golfer, path: self.$path)
                    
                } label: {
                    Label("History", systemImage: "list.bullet")
                    Divider()
                }
            }
            Spacer()
            
            
        }
        .padding(.horizontal)
        .navigationTitle("Rounds")
        .navigationBarBackButtonHidden()
        
        
    }
}

struct RoundView_Previews: PreviewProvider {
    
    @State private static var golfer = Golfer.golfer
    @State private static var navStack = NavigationPath()
    static var previews: some View {
        RoundView(golfer: $golfer, path: $navStack)
    }
}
