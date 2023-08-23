//
//  StatView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-24.
//

import SwiftUI

struct StatView: View {
    @State private var startDate: Date = .now.jumpDaysAhead(by: -100)
    @State private var endDate: Date = .now

    @State private var roundTypes: [RoundType] = RoundType.allCases
    @Binding var path: NavigationPath
    let golfer: Golfer
    
    @State private var ratingBound: Range<Double> = 67.0..<75.0
    var rounds: [Round] {
        return golfer.rounds.filter { round in
            return round.date > startDate && round.date < endDate && roundTypes.contains(round.roundType)
                
            
        }
    }
    
    
    var body: some View {
        VStack {
            RoundFilterView(startDate: self.$startDate, endDate: self.$endDate, roundType: $roundTypes, ratingBound: $ratingBound)
            
            Spacer()
            
            Button {
                path.append(rounds)
            } label: {
                Label("Compile Report", systemImage: "chart.dots.scatter")
            }
            .disabled(rounds.isEmpty)
            
            
            List(rounds) { round in
                HStack {
                    
                    
                    Text(round.course.name)
                           
                        
                    Text(round.date.formatted(date: .abbreviated, time: .omitted))
                        .fontWeight(.light)
                    
                    Spacer()
                    Text(String(round.roundScore))
                        .fontWeight(.semibold)
                    
                    
                }
            }
            
            
            
        }
        .animation(.easeInOut, value: self.roundTypes)
        .animation(.easeInOut, value: self.ratingBound)
        .animation(.easeInOut, value: self.startDate)
        .animation(.easeInOut, value: self.endDate)
        .padding()
        .navigationBarBackButtonHidden()
    }
    
}

struct StatView_Previews: PreviewProvider {
    @State private static var path = NavigationPath()
    static var previews: some View {
        StatView(path: $path, golfer: Golfer.golfer)
    }
}
