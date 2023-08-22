//
//  StatAnalysisView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-08-21.
//

import SwiftUI

struct StatAnalysisView: View {
    let rounds: [Round]
    @State private var statFocus: StatFocus?
    
    var body: some View {
        VStack {
            GroupBox {
                GeneralStatView(rounds: self.rounds)
            } label: {
                Text("General")
            }
            .onTapGesture {
                statFocus = .general
            }
            
            GroupBox {
                DrivingStatView(rounds: self.rounds)
            } label: {
                Text("Driving")
            }
            .onTapGesture {
                statFocus = .driving
            }
            
            GroupBox {
                ApproachStatView(rounds: self.rounds)
            } label: {
                Text("Approach")
            }
            .onTapGesture {
                statFocus = .approach
            }
            
            GroupBox {
                PuttingStatView()
            } label: {
                Text("Putting")
            }
            .onTapGesture {
                statFocus = .putting
            }
            
            GroupBox {
                ShortGameStatView(rounds: self.rounds)
            } label: {
                Text("Short Game")
            }
            .onTapGesture {
                statFocus = .shortGame
            }
            
        }
        .sheet(item: self.$statFocus) { focus in
            switch focus {
            case .shortGame:
                ShortGameStatView(rounds: self.rounds)
            case .general:
                GeneralStatView(rounds: self.rounds)
            case .driving:
                DrivingStatView(rounds: self.rounds)
            case .putting:
                PuttingStatView()
            case .approach:
                ApproachStatView(rounds: self.rounds)
            }
        }
    }
    
    enum StatFocus : Identifiable {
        var id: Self { self }
        
        case shortGame
        case general
        case driving
        case putting
        case approach
    }
}



struct StatAnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        StatAnalysisView(rounds: [Round.completeRoundExample1])
    }
}
