//
//  ShotElement.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-28.
//

import SwiftUI

struct ShotElement: View {
    @Binding var shot: ShotIntermediate
    
    var body: some View {
        
            
            
        HStack {
            
            let yardageBinding = Binding<String> {
                return "\(self.shot.position.yardage.yardage)"
            } set: { newValue in
                if let yardage = Int(newValue) {
                    self.shot.position.yardage = Distance(yards: yardage)
                } else {
                    self.shot.position.yardage = Distance(yards: 0)
                }
            }
            
            
            TextField("Yardage", text: yardageBinding)
                .textFieldStyle(.roundedBorder)
                .frame(width: 60, alignment: .center)
                .keyboardType(.numberPad)
                .textContentType(.none)
                .font(.system(size: 15))
            
            // TODO: make this a custom binding which actually works. May have to implement testing on the simulator.
            
            Picker(selection: $shot.position.lie) {
                ForEach(Lie.allCases) { shotType in
                    Text(shotType.rawValue)
                    
                }
            } label: { }
                .pickerStyle(.menu)
            
            
            
            Picker(selection: $shot.type) {
                ForEach(ShotType.allCases, id: \.self) { shotType in
                    Text(shotType.rawValue)
                }
            } label: {
                //empty label block
            }
            .pickerStyle(.menu)
            
            
            
        }
        
    }
}

struct ShotElement_Previews: PreviewProvider {
    @State private static var shot = ShotIntermediate(position: Position(lie: .fairway, yardage: Distance(yards: 150)),  type: .drive)
    static var previews: some View {
        ShotElement(shot: self.$shot)
    }
}
