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
                HStack {
                    Spacer()
                    Text("Scoring Average")
                        .bold()
                    
                    Text(String(format: "%.1f", (rounds.scoringAverage() ?? 0)))
                    
                    
                    Spacer()
                    
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.white)
                }
            } label: {
                HStack {
                    Text("General")
                        .font(.title)
                        .bold()
                    Spacer()
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .foregroundColor(.accentColor)
                }
            }
            .onTapGesture {
                statFocus = .general
            }
            
            GroupBox {
                StrokesGainedListElement(statFocus: .driving, rounds: self.rounds)
                
            } label: {
                HStack {
                    Text("Driving")
                        .font(.title)
                        .bold()
                    Spacer()
                    
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .foregroundColor(.accentColor)
                }
                
            }
            .onTapGesture {
                statFocus = .driving
            }
            
            GroupBox {
                StrokesGainedListElement(statFocus: .approach, rounds: self.rounds)
            } label: {
                HStack {
                    Text("Approach")
                        .font(.title)
                        .bold()
                    Spacer()
                    
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .foregroundColor(.accentColor)
                }
                
            }
            .onTapGesture {
                statFocus = .approach
            }
            
            GroupBox {
                StrokesGainedListElement(statFocus: .putting, rounds: self.rounds)
            } label: {
                HStack {
                    Text("Putting")
                        .font(.title)
                        .bold()
                    Spacer()
                    
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .foregroundColor(.accentColor)
                }
            }
            .onTapGesture {
                statFocus = .putting
            }
            
            GroupBox {
                StrokesGainedListElement(statFocus: .shortGame, rounds: self.rounds)
            } label: {
                HStack {
                    Text("Short Game")
                        .font(.title)
                        .bold()
                    Spacer()
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .foregroundColor(.accentColor)
                }
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
                PuttingStatView(rounds: self.rounds)
            case .approach:
                ApproachStatView(rounds: self.rounds)
            }
        }
        .navigationTitle("Statistics")
        .padding()
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

struct StrokesGainedListElement : View {
    let statFocus: StatFocus
    let rounds: [Round]
    
    var strokesGainedTuple: (Double?, Int, Int) {
        
        if let focus = self.getShotFromFocus() {
            return rounds.strokesGained(for: focus)
        } else {
            return (0, 0, 0)
        }
    }
    
    var body: some View {
        
        HStack {
            Spacer()
            Text("Per Shot")
                .bold()
            
            Text(String(format: "%.2f", (strokesGainedTuple.0 ?? 0) / Double(strokesGainedTuple.1)))
            
           
            Spacer()
    
            Text("Per Round")
                .bold()
            
            Text(String(format: "%.2f", (strokesGainedTuple.0 ?? 0) / Double(strokesGainedTuple.2)))
            Spacer()
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.white)
        }
        
        
    }
    
    func getShotFromFocus() -> ShotType? {
        switch self.statFocus {
        case .shortGame:
            return .chip_pitch
        case .approach:
            return .approach
        case .putting:
            return .putt
        case .driving:
            return .drive
        default:
            return nil
        }
    }
    
    
    
}





struct StatAnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StatAnalysisView(rounds: [Round.completeRoundExample1])
        }
    }
}
