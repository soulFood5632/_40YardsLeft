//
//  ChippingAnalysisView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-08-21.
//

import SwiftUI

struct ChippingAnalysisView: View {
    let shots: [Shot]
    @State var distanceBounds: Range<Distance> = .yards(0)..<Distance.yards(50)
    @State var lies: [Lie] = [.fairway, .rough]
    

    
    
    
    
    var strokesGained: (Double, Int) {
        return (shots.strokesGained(ShotFilters.allShortGame), shots.filter(ShotFilters.allShortGame).count)
    }
    
    var inside8Percentage: (Double?, Int) {
        return (shots.percentageInsideProx(maxDistance: .feet(8), range: .zero..<Distance.yards(100), lie: Lie.allCases, shotType: .chip_pitch), shots.filter { $0.type == .chip_pitch}.count)
    }
    
    var proximity: (Distance?, Int) {
        return (shots.approachProximityFrom(range: .zero..<Distance.MAX_DISTANCE, lie: Lie.allCases, shotType: .chip_pitch), shots.filter { $0.type == .chip_pitch }.count)
    }
    
    func strokesGainedWithFilters(range: Range<Distance>, lies: [Lie]) -> (Double, Int) {
        
        let strokesGained = shots.strokesGained { shot in
            return range.contains(shot.startPosition.yardage) && lies.contains(shot.startPosition.lie) && shot.type == .chip_pitch
        }
        
        let totalShots = shots
            .filter { range.contains($0.startPosition.yardage) }
            .filter { lies.contains($0.startPosition.lie) }
            .filter { $0.type == .chip_pitch }
            .count
        
        return (strokesGained, totalShots)
        
    }
    
    func proximityInRange(range: Range<Distance>) -> (Distance?, Int) {
        (shots.approachProximityFrom(range: range, lie: Lie.allCases, shotType: .chip_pitch), shots.filter { $0.type == .chip_pitch && range.contains( $0.startPosition.yardage) }.count)
    }
    
    func proximityInRangeWithLies(range: Range<Distance>, lies: [Lie]) -> (Distance?, Int) {
        (shots.approachProximityFrom(range: range, lie: lies, shotType: .chip_pitch), shots.filter { $0.type == .chip_pitch && range.contains( $0.startPosition.yardage) && lies.contains($0.startPosition.lie) }.count)
    }
    
    func inside8feetRate(range: Range<Distance>, lies: [Lie]) -> (Double?, Int) {
        (shots.percentageInsideProx(maxDistance: .feet(8), range: range, lie: lies, shotType: .chip_pitch), shots.filter { $0.type == .chip_pitch && range.contains( $0.startPosition.yardage) && lies.contains($0.startPosition.lie) }.count)
    }
    
    
    
    
    var body: some View {
        VStack {
            
            Text("Chipping Detail View")
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
                    
                    if strokesGained.1 == 0 {
                        Text("0 per shot")
                            .font(.caption)
                    } else {
                        Text("\(strokesGainedPerShot, specifier: "%.2f") per shot")
                            .font(.caption)
                    }
                }
                
                
            }
            GroupBox {
                Grid {
                    GridRow {
                        Text("Proximity")
                            .bold()
                        Text("8 Feet Rate")
                            .bold()
                    }
                    
                    Divider()
                    
                    GridRow {
                        Text("\(self.proximity.0?.feet ?? 0, specifier: "%.1f") ft.")
                        
                        Text("\((self.inside8Percentage.0 ?? 0) * 100, specifier: "%.0f")%")
                    }
                }
            }
            
            Divider()
                .padding()
            
            
            
            HStack {
                
                let lowerBoundBinding: Binding<Double> = Binding {
                    return self.distanceBounds.lowerBound.yards
                } set: { newValue in
                    self.distanceBounds.safeLowerBoundUpdate(newBound: .yards(newValue))
                    
                }
                
                Spacer()
                
                TextField("Yards", value: lowerBoundBinding, formatter: .wholeNumber)

                    .textFieldStyle(.roundedBorder)
                
                Text(" to ")
                
                let upperBoundBinding: Binding<Double> = Binding {
                    return self.distanceBounds.upperBound.yards
                } set: { newValue in
                    self.distanceBounds.safeUpperBoundUpdate(newBound: .yards(newValue))
                }
                
                TextField("Yards", value: upperBoundBinding, formatter: .wholeNumber)
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
            
            Button {
                // get rid of text boxes

            } label: {
                Label {
                    Text("Save")
                } icon: {
                    Image(systemName: "checkmark")
                }

            }
            .buttonStyle(.borderedProminent)
            
            
            
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
                        
                        let successData = self.inside8feetRate(range: self.distanceBounds, lies: self.lies)
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



struct ChippingAnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        ChippingAnalysisView(shots: Shot.exampleShotList)
    }
}
