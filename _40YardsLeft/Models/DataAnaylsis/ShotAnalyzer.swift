//
//  ShotAnalyzer.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-05-08.
//

import Foundation


extension Array where Element == Shot {
    
    /// Gets the average proximity of an approach with the given filters.
    ///
    /// - Parameters:
    ///   - range: The range of yardages in which this report should be calculated from.
    ///   - lie: A list of lies which contains at least one entry and is only rough or fairway.
    ///
    /// - Returns: The average distance of shot from the given filters. Nil if no shots are present at such a distance.
    func proximityFrom(range: Range<Distance>, lie: [Lie]) -> Distance? {
        self.filter { $0.type == .approach }
            .filter { lie.contains($0.startPosition.lie) && range.contains($0.startPosition.yardage) }
            .map { $0.endPosition.yardage }
            .average()
    }
    
    
    /// Gets the percentages of greens hit from a given range.
    ///
    /// - Parameter range: The range of yardages in which this report should be calculated from.
    ///
    /// - Returns: A double where 1 = 100% success and 0 = 0% success
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
    
    func averageProximityFrom(range: Range<Distance>) -> Distance? {
        return self.filter { $0.type == .putt }
            .filter { range.contains($0.startPosition.yardage) }
            .map { $0.endPosition.yardage }
            .average()
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
