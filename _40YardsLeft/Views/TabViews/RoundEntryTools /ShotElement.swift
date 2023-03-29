//
//  ShotElement.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-28.
//

import SwiftUI

struct ShotElement: View {
    @Binding var shot: ShotIntermediate
    
    @State private var friend = true
    var body: some View {
        
            
            
        HStack {
            
            TextField("Yardage", text: $shot.distance)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
            
            // TODO: make this a custom binding which actually works. May have to implement testing on the simulator.
            
            Picker("", selection: $shot.lie) {
                ForEach(Lie.allCases) { shotType in
                    Text(shotType.rawValue)
                }
            }
            .pickerStyle(.menu)
            
            Picker("hello", selection: $shot.type) {
                ForEach(ShotType.allCases, id: \.self) { shotType in
                    Text(shotType.rawValue)
                }
            }
            .pickerStyle(.menu)
            
            Button {
                //TODO: make pop up screen on hold
            } label: {
                Image(systemName: "ellipsis")
            }
            
            
            
        }
        
        .padding()
        
    }
}

struct ShotElement_Previews: PreviewProvider {
    @State private static var shot = ShotIntermediate(distance: "", lie: .tee,  type: .drive)
    static var previews: some View {
        ShotElement(shot: self.$shot)
    }
}
