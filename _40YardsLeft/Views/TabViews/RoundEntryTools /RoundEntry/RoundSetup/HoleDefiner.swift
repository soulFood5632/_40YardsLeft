//
//  HoleDefiner.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-01.
//

import SwiftUI

struct HoleDefiner: View {
    @Binding var holeDataList: [HoleData]
    var body: some View {
        Grid {
            ForEach(1...holeDataList.count) { holeNum in
                
                GridRow {
                    
                    SingleHoleText(holeData: self.$holeDataList[holeNum - 1], holeNumber: holeNum)
                }
            }
        }
    
    }
}

struct SingleHoleText: View {
    @Binding var holeData: HoleData
    let holeNumber: Int
    var body: some View {
        
        //TODO: add smart autofill for holedata so that par automatically updates with soft reference 
        
            Text("\(holeNumber).")
                .bold()
            
        TextField("Yardage", value: self.$holeData.yardage.yards, formatter: .wholeNumber)
            .keyboardType(.numberPad)
            .onChange(of: self.holeData.yardage, perform: { yardage in
                self.holeData.par = ShotPredictor.getParFromYardage(distance: yardage)
            })
            .onAppear {
                self.holeData.par = ShotPredictor.getParFromYardage(distance: self.holeData.yardage)
            }
            
            Picker("", selection: self.$holeData.par) {
                ForEach(possiblePars) { par in
                    Text("\(par)")
                }
            }
            
            Picker("", selection: self.$holeData.handicap) {
                ForEach(possibleHandicaps) { handicap in
                    Text("\(handicap)")
                }
            }
            

    }
    
    
}

extension SingleHoleText {
    private var possibleHandicaps: [Int] {
        var list = [Int]()
        for num in 1...18 {
            list.append(num)
        }
        
        return list
    }
    
    private var possiblePars: [Int] { [3, 4, 5] }
}

struct HoleDefiner_Previews: PreviewProvider {
    @State private static var holeData = [HoleData(yardage: .yards(400), handicap: 12, par: 10)]
    static var previews: some View {
        HoleDefiner(holeDataList: self.$holeData )
    }
}

extension ShotPredictor {
    /// Gets a predicted par from the provided yardage.
    ///
    /// The values will correspond as follows
    ///  - < 250 yards -> 3
    ///  - \> 500 yards -> 5
    ///  - Otherwise -> 4
    ///
    ///
    /// - Parameter distance: The distance you would like to calculate the expected par of
    /// - Returns: The expected par value
    static func getParFromYardage(distance: Distance) -> Int {
        if distance.yards < 250 {
            return 3
        }
        if distance.yards > 500 {
            return 5
        }
        
        return 4
    }
}
