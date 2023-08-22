//
//  StatTable.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-08-21.
//

import SwiftUI

struct StatTable<T: CustomStringConvertible, V: CustomStringConvertible>: View where T: _FormatSpecifiable {
    
    let titleValuePairs: [DisplayStat<T, V>]
    
    var body: some View {
        
        
        ForEach(titleValuePairs) { displayStat in
            
            HStack {
                Text(displayStat.name + ":")
                    .bold()
                
                Spacer()
                
                
                Group {
                    if let totalData = displayStat.numOfSamples {
                        VStack {
                            if displayStat.isPercent {
                                Text("\(displayStat.value, specifier: displayStat.formatter)%")
                            } else {
                                Text("\(displayStat.value, specifier: displayStat.formatter)")
                            }
                            
                            Text(totalData.description)
                                .font(.caption)
                        }
                        
                    } else {
                        Text("\(displayStat.value, specifier: displayStat.formatter)")
                        
                    }
                }
                .frame(width: 60)
            }
            
            
        }
    }
}

struct DisplayStat <T: CustomStringConvertible, V: CustomStringConvertible>: Identifiable where T: _FormatSpecifiable  {
    let numOfSamples: V?
    let value: T
    let name: String
    let formatter: String
    var isPercent: Bool = false
    
    let id: UUID = UUID()
    
    init(name: String, value: T, numOfSamples: V, formatter: String, isPercent: Bool) {
        self.numOfSamples = numOfSamples
        self.value = value
        self.name = name
        self.formatter = formatter
        self.isPercent = true
    }
    
    init(name: String, value: T, numOfSamples: V, formatter: String) {
        self.numOfSamples = numOfSamples
        self.value = value
        self.name = name
        self.formatter = formatter
    }
    
    init(name: String, value: T, formatter: String) {
        self.value = value
        self.name = name
        self.formatter = formatter
        self.numOfSamples = nil
    }
    
}

struct StatTable_Previews: PreviewProvider {
    static var previews: some View {
        StatTable<Double, Int>(titleValuePairs: [
            DisplayStat(name: "Birdies", value: 10.0, formatter: "%.1f"),
            DisplayStat(name: "Eagles+", value: 10, numOfSamples: 100, formatter: "%.0f")
            
            
            
        ])
    }
}
