//
//  ShotAnalyzer.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-05-08.
//

import Foundation


// This array extension will be responsible for all statistics which are shot independant. All stats that have depencency on the shots around it, the holedata, must be calcuated elsewhere
extension Array where Element == Shot {
    
    
    /// Gets the average proximity using the provided filter.
    ///
    /// - Parameter filter: A filter which informs which shots to include in this calculation
    /// - Returns: A optional distance value which houses the average prxomity of the shots. Nil if the filter outputted no valid values
    func proximityFrom(_ filter: @escaping (Shot) -> Bool) -> Distance? {
        self.filter(filter)
            .map { $0.endPosition.yardage }
            .average()
    }
    

    
    /// Gets the average proximity of an approach with the given filters.
    ///
    /// - Parameters:
    ///   - range: The range of yardages in which this report should be calculated from.
    ///   - lie: A list of lies which contains at least one entry and is only rough or fairway.
    ///
    /// - Returns: The average distance of shot from the given filters. Nil if no shots are present at such a distance.
    func approachProximityFrom(range: Range<Distance>, lie: [Lie]) -> Distance? {
        self.filter { $0.type == .approach }
            .filter { lie.contains($0.startPosition.lie) && range.contains($0.startPosition.yardage) }
            .map { $0.endPosition.yardage }
            .average()
    }
    
    
    /// Gets the percentages of greens hit from a given range.
    ///
    /// - Parameter range: The range of yardages in which this report should be calculated from.
    ///
    /// - Returns: A double where 1 = 100% success and 0 = 0% success. Nil is returned if no approach shots are present.
    func greenPercentageFrom(range: Range<Distance>, lie: [Lie]) -> Double? {
        let value = self.filter { $0.type == .approach }
            .filter { lie.contains($0.startPosition.lie) && range.contains($0.startPosition.yardage) }
            .map { $0.endPosition.lie }
            .map { lie in
                if lie == .green {
                    return 1
                }
                return 0
            }
        
        return value.average()
        
    }
    

    
    
    /// Gets the make percentage from the provided range of values.
    /// - Parameter range: <#range description#>
    /// - Returns: <#description#>
    func makePercentageFrom(range: Range<Distance>) -> Double? {
        let value = self.filter { $0.type == .putt }
            .filter { range.contains($0.startPosition.yardage) }
            .map { $0.endPosition }
            .map { position in
                if position == .holed {
                    return 1
                }
                return 0
            }.average()
        
        return value
    }
    
    
    func puttProximityFrom(range: Range<Distance>) -> Distance? {
        return self.filter { $0.type == .putt }
            .filter { range.contains($0.startPosition.yardage) }
            .map { $0.endPosition.yardage }
            .average()
    }
    
    
    
    func strokesGained(_ filter: @escaping (Shot) -> Bool) -> Double {
        //Note that the optional value should never be reached for any complete round.
        self.filter(filter)
            .map { $0.strokesGained ?? 0 }
            .sum()
    }
    
    
    
    
}

extension Array where Element == Distance {
    
    /// Gets the average distance of the provided list.
    ///
    /// - Returns: A distance value which represents the average of a list of distances. Returns nil if the list ios empty
    func average() -> Distance? {
        if self.isEmpty {
            return nil
        }
        
        let countAndTotal = self.reduce((0, Distance.zero)) { partialResult, newDistance in
            return (partialResult.0 + 1, partialResult.1 + newDistance)
        }
        
        return countAndTotal.1.scaleBy(Double(1) / Double(countAndTotal.0))
        
        
        
    }
}

extension Array where Element == Double {
    
    /// Gets a sum of all the elements in this array.
    ///
    /// - Returns: A double value containing a sum of all elements in this
    func sum() -> Double {
        self.reduce(0.0) { partialResult, newValue in
            return partialResult + newValue
        }
    }
}


