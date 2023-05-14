//
//  ShotElement.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-28.
//

import SwiftUI

struct ShotElement: View {
    @Binding var shot: ShotIntermediate
    
    @Binding var isFinal: Bool
    
    var body: some View {
        
        Group {
            if !isFinal {
                
                let isOnGreen = shot.position.lie == .green
                VStack {
                    TextField("To Hole",
                              value: isOnGreen ?  $shot.position.yardage.feet : $shot.position.yardage.yards,
                              formatter: .wholeNumber)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 50, alignment: .center)
                    .keyboardType(.numberPad)
                    .textContentType(.none)
                    .font(.system(size: 15))
                    
                    Text(isOnGreen ? "Feet" : "Yards")
                        .font(.caption2)
                }
                
                
                
                
                
                
                Picker(selection: $shot.position.lie) {
                    ForEach(Lie.allCases) { shotType in
                        Text(shotType.rawValue)
                        
                    }
                } label: { } // empty label becuase it does not matter.
                    .pickerStyle(.menu)
                
                
                
                
                
                Picker(selection: $shot.declaration) {
                    ForEach(ShotIntermediate.ShotDeclaration.allCases) { shotType in
                        Text(shotType.rawValue)
                        
                    }
                } label: {
                    //empty label block
                }
                .pickerStyle(.menu)

            } else {
                
                VStack {
                    let isOnGreen = shot.position.lie == .green
                    Text("\(isOnGreen ? shot.position.yardage.feet : shot.position.yardage.yards, format: .number)")
                    
                    
                    Text(isOnGreen ? "Feet" : "Yards")
                        .font(.caption2)
                        
                }
                

                Text(shot.position.lie.rawValue)
                
                Text(shot.declaration.rawValue)
                
            }
            
        }
        
        
        
    }
}

struct ShotElement_Previews: PreviewProvider {
    @State private static var shot = ShotIntermediate(position: Position(lie: .fairway, yardage: Distance(yards: 150)), declaration: .drive)
    @State private static var isFinal = false
    static var previews: some View {
        Grid {
            GridRow {
                ShotElement(shot: self.$shot, isFinal: $isFinal)
            }
            Button {
                isFinal.toggle()
            } label: {
                Text("Toggle isFinal")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
