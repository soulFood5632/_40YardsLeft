//
//  DistanceAndLieFilter.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-08-22.
//

import SwiftUI

struct DistanceAndLieFilter: View {
    @Binding var distanceBounds: Range<Distance>
    @Binding var lies: [Lie]
    var body: some View {
        HStack {
            
            let lowerBoundBinding: Binding<Double> = Binding {
                return self.distanceBounds.lowerBound.yards
            } set: { newValue in
                self.distanceBounds.safeLowerBoundUpdate(newBound: .yards(newValue))
                
            }
            
            Spacer()
            
            TextField("", value: lowerBoundBinding, formatter: .wholeNumber)
                .textFieldStyle(.roundedBorder)
            
            Text(" to ")
            
            let upperBoundBinding: Binding<Double> = Binding {
                return self.distanceBounds.upperBound.yards
            } set: { newValue in
                self.distanceBounds.safeUpperBoundUpdate(newBound: .yards(newValue))
            }
            
            TextField("", value: upperBoundBinding, formatter: .wholeNumber)
                .textFieldStyle(.roundedBorder)
            Spacer()
            
        }
        
        HStack {
            Spacer()
            ForEach([Lie.fairway, Lie.rough, Lie.bunker]) { lie in
                
                Label {
                    Text(lie.rawValue)
                        .foregroundColor(self.lies.contains(lie) ? .accentColor : .primary)
                } icon: {
                    Image(systemName: self.lies.contains(lie) ? "checkmark.circle" : "circle")
                    
                }
                .bold(self.lies.contains(lie))
                
                .onTapGesture {
                    if !self.lies.contains(lie) {
                        self.lies.append(lie)
                    } else {
                        self.lies.removeAll { $0 == lie }
                    }
                }
                
                Spacer()
            }
        }
    }
}


