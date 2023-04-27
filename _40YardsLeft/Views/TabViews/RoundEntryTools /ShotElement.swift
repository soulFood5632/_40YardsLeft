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
            
            TextField("Yardage", value: $shot.position.yardage.yards, formatter: .wholeNumber)
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
            } label: { } // empty label becuase it does not matter. 
                .pickerStyle(.menu)
            
            
            
            Picker(selection: $shot.declaration) {
                ForEach(ShotIntermediate.ShotDeclaration.allCases, id: \.self) { shotType in
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
    @State private static var shot = ShotIntermediate(position: Position(lie: .fairway, yardage: Distance(yards: 150)), declaration: .drive)
    static var previews: some View {
        ShotElement(shot: self.$shot)
    }
}
