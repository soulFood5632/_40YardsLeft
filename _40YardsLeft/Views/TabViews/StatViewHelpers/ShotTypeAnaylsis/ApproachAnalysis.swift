//
//  ApproachAnalysis.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-08-18.
//

import SwiftUI

struct ApproachAnalysis: View {
    let shots: [Shot]
    @State var distanceBounds: Range<Distance> = .yards(50)..<Distance.yards(300)
    @State var lies: [Lie] = [.fairway]


    
    var strokesGained: (Double, Int) {
        return (shots.strokesGained(ShotFilters.allApproach), shots.filter { $0.type == .approach }.count)
    }
    
    var successRate: (Double?, Int) {
        return (shots.greenPercentageFrom(range: .zero..<Distance.MAX_DISTANCE, lie: Lie.allCases, shotType: .approach), shots.filter { $0.type == .approach }.count)
    }
    
    var proximity: (Distance?, Int) {
        return (shots.approachProximityFrom(range: .zero..<Distance.MAX_DISTANCE, lie: Lie.allCases, shotType: .approach), shots.filter { $0.type == .approach }.count)
    }
    
    func strokesGainedWithFilters(range: Range<Distance>, lies: [Lie]) -> (Double, Int) {
        
        let strokesGained = shots.strokesGained { shot in
            return range.contains(shot.startPosition.yardage) && lies.contains(shot.startPosition.lie) && shot.type == .approach
            
        }
        
        let totalShots = shots
            .filter { range.contains($0.startPosition.yardage) }
            .filter { lies.contains($0.startPosition.lie) }
            .filter { $0.type == .approach }
            .count
        
        return (strokesGained, totalShots)

    }
    
    func proximityInRange(range: Range<Distance>) -> (Distance?, Int) {
        (shots.approachProximityFrom(range: range, lie: Lie.allCases, shotType: .approach), shots.filter { $0.type == .approach && range.contains( $0.startPosition.yardage) }.count)
    }
    
    func proximityInRangeWithLies(range: Range<Distance>, lies: [Lie]) -> (Distance?, Int) {
        (shots.approachProximityFrom(range: range, lie: lies, shotType: .approach), shots.filter { $0.type == .approach && range.contains( $0.startPosition.yardage) && lies.contains($0.startPosition.lie) }.count)
    }
    
    func successInRangeWithLies(range: Range<Distance>, lies: [Lie]) -> (Double?, Int) {
        (shots.greenPercentageFrom(range: range, lie: lies, shotType: .approach), shots.filter { $0.type == .approach && range.contains( $0.startPosition.yardage) && lies.contains($0.startPosition.lie) }.count)
    }
    
    
    
    
    var body: some View {
            VStack {
                
                Text("Approach Detail View")
                    .font(.title)
                    .bold()
                Text("\(self.strokesGained.1) shots")
                
                Divider()
                
                
                HStack {
                    Text("Strokes Gained:")
                        .font(.title3)
                        .bold()
                    
                    VStack {
                        Text("\(self.strokesGained.0, specifier: "%.1f")")
                            .bold()
                        
                        
                        let strokesGainedPerShot = self.strokesGained.0 / Double(self.strokesGained.1)
                        
                        Text("\(strokesGainedPerShot, specifier: "%.2f") per shot")
                            .font(.caption)
                    }
                        
                    
                }
                GroupBox {
                    Grid {
                        GridRow {
                            Text("Proximity")
                                .bold()
                            Text("Success Rate")
                                .bold()
                        }
                        
                        Divider()
                        
                        GridRow {
                            Text("\(self.proximity.0?.feet ?? 0, specifier: "%.1f") ft.")
                            
                            Text("\((self.successRate.0 ?? 0) * 100, specifier: "%.0f")%")
                        }
                    }
                }
                
                Divider()
                    .padding()
                
                        
//                        Text("Filters")
//                            .font(.title3)
//                            .bold()
                        
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
                        
                    
                    
                    GroupBox {
                        Grid(horizontalSpacing: 20) {
                            GridRow {
                                Text("Strokes Gained:")
                                    .bold()
                                    
                                
                                
                                
                                VStack {
                                    let strokesGainedData = self.strokesGainedWithFilters(range: self.distanceBounds, lies: self.lies)
                                    
                                    Text("\(strokesGainedData.0, specifier: "%.1f") ")
                                        .bold()
                                    
                                    if (strokesGainedData.1 == 0) {
                                        Text("0 per shot")
                                            .font(.caption)
                                    } else {
                                        Text("\(strokesGainedData.0 / Double(strokesGainedData.1), specifier: "%.2f") per shot")
                                            .font(.caption)
                                    }
                                }
                                .frame(width: 100)
                            }
                            
                            GridRow {
                                Text("Proximity:")
                                    .bold()
                                
                                let proxData = self.proximityInRangeWithLies(range: self.distanceBounds, lies: self.lies)
                                VStack {
                                    Text("\(proxData.0?.feet ?? 0, specifier: "%.1f") ft.")
                                        .bold()
                                    
                                    Text("\(proxData.1)")
                                        .font(.caption)
                                }
                                .frame(width: 100)
                                
                                
                            }
                            .padding(.vertical, 5)
                            
                            GridRow {
                                Text("Success Rate:")
                                    .bold()
                                
                                let successData = self.successInRangeWithLies(range: self.distanceBounds, lies: self.lies)
                                VStack {
                                    Text("\((successData.0 ?? 0) * 100, specifier: "%.0f")%")
                                        .bold()
                                    
                                    Text("\(successData.1)")
                                        .font(.caption)
                                }
                                .frame(width: 100)
                                
                                
                            }
                            
                        }
                    }
                    
                    
                
            }

        
        .animation(.easeInOut, value: self.lies)
        .animation(.easeInOut, value: self.distanceBounds)
        
    }
}

extension Range {
    mutating func safeLowerBoundUpdate(newBound: Bound) {
        if newBound < self.upperBound {
            self = newBound..<self.upperBound
        }
    }
    
    mutating func safeUpperBoundUpdate(newBound: Bound) {
        if newBound > self.lowerBound {
            self = self.lowerBound..<newBound
        }
    }
}
                                     

                                     
                                    
                                     
                                     


struct ApproachAnalysis_Previews: PreviewProvider {
    
    static var previews: some View {
        ApproachAnalysis(shots: Shot.exampleShotList)
            .padding()
    }
}
