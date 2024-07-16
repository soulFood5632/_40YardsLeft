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
    @FocusState var textFocus: Bool
    
    @State var isLoaded = false
    
    @State var isAtHole = false
    @State var isDrop = false
    
    
    var body: some View {
        
        Group {
            if !isFinal {
                let isOnGreen = shot.position.lie == .green
                VStack {
                    TextField("To Hole",
                                value: isOnGreen ?  $shot.position.yardage.feet : $shot.position.yardage.yards,
                              formatter: .wholeNumber)
                        .focused($textFocus)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 45, alignment: .center)
                        .keyboardType(.asciiCapableNumberPad)
                        .textContentType(.none)
                        .backgroundStyle(textFocus ? .gray : .green)
                        .onTapGesture(perform: {
                            textFocus = false
                        })
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
                    .onTapGesture(perform: {
                        textFocus = false
                    })
                
                Toggle(isOn: self.$isAtHole) {
                    //empty label
                }
                .toggleStyle(iOSCheckboxToggleStyle())
            
                Toggle(isOn: self.$isDrop) {
                    // empty label
                }
                .toggleStyle(iOSCheckboxToggleStyle())
                
    
                
                
                .onTapGesture{
                    self.hasChangedDecleration = true;
                    textFocus = false
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
                
                
                Image(systemName: self.isAtHole ? "checkmark.square" : "square")
                Image(systemName: self.isDrop ? "checkmark.square" : "square")
                
                
                
                
            }
            
        }
        .onChange(of: self.isDrop) { newValue in
            if self.isLoaded {
                if newValue == true {
                    self.isAtHole = false
                }
                mapDeclare()
            }
            
        }
        .onChange(of: self.isAtHole) { newValue in
            if self.isLoaded {
                if newValue == true {
                    self.isDrop = false
                }
                mapDeclare()
            }
            
        }
        .onAppear {
            if self.shot.declaration == .atHole {
                self.isAtHole = true
            } else if self.shot.declaration == .drop {
                self.isDrop = true
            }
            self.isLoaded = true
        }
        
       
        .animation(.easeInOut, value: self.textFocus)
        
        
        
        
    }
}

extension ShotElement {
    
    func mapDeclare() {
        precondition(!(isAtHole && isDrop))
        
        if isAtHole {
            self.shot.declaration = .atHole
        } else if isDrop {
            self.shot.declaration = .drop
        } else if self.shot.position.lie == .tee {
            self.shot.declaration = .drive
        } else {
            self.shot.declaration = .other
        }
        
    }
    
    
    func setDeclarationFrom(lie: Lie) {
        let yardage = self.shot.position.yardage
        switch lie {
        case .tee:
            break
            // had to remove this section becuase it changed par 3's to drives whomp whomp
//            self.shot.declaration = .drive
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
        case .penalty:
            self.shot.declaration = .drop
        case .bunker:
            if yardage > .yards(190) {
                self.shot.declaration = .other
            } else {
                self.shot.declaration = .atHole
            }
        case .green:
            self.shot.declaration = .atHole
        }
    }
}

struct ShotElement_Previews: View {
    @State private var shot = ShotIntermediate(position: Position(lie: .fairway, yardage: Distance(yards: 150)), declaration: .drive)
    @State private var isFinal = false
    var body: some View {
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

#Preview {
    ShotElement_Previews()
}


struct iOSCheckboxToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()

        }, label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                
                configuration.label
            }
        })
    }
}
