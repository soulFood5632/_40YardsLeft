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
    
    @State var hasChangedDecleration = false
    
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
                .onTapGesture{
                    self.hasChangedDecleration = true;
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
        .onChange(of: self.shot.position.lie) { newLie in
            if !hasChangedDecleration {
                setDeclarationFrom(lie: newLie)
            }
        }
        
        
        
        
    }
}

extension ShotElement {
    func setDeclarationFrom(lie: Lie) {
        let yardage = self.shot.position.yardage
        switch lie {
        case .tee:
            self.shot.declaration = .drive
        case .fairway:
            if yardage > .yards(300) {
                self.shot.declaration = .other
            } else {
                self.shot.declaration = .atHole
            }
        case .rough:
            if yardage > .yards(275) {
                self.shot.declaration = .other
            } else {
                self.shot.declaration = .atHole
            }
        case .recovery:
            self.shot.declaration = .other
        case .bunker:
            if yardage > .yards(190) {
                self.shot.declaration = .other
            } else {
                self.shot.declaration = .atHole
            }
        case .penalty:
            self.shot.declaration = .drop
        case .green:
            self.shot.declaration = .atHole
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
