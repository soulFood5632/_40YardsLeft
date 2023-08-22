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
    func approachProximityFrom(range: Range<Distance>, lie: [Lie], shotType: ShotType) -> Distance? {
        self.filter { $0.type == shotType }
            .filter { lie.contains($0.startPosition.lie) && range.contains($0.startPosition.yardage) }
            .map { $0.endPosition.yardage }
            .average()
    }
    
    
    /// Gets the percentages of greens hit from a given range.
    ///
    /// - Parameter range: The range of yardages in which this report should be calculated from.
    ///
    /// - Returns: A double where 1 = 100% success and 0 = 0% success. Nil is returned if no approach shots are present.
    func greenPercentageFrom(range: Range<Distance>, lie: [Lie], shotType: ShotType) -> Double? {
        let value = self.filter { $0.type == shotType }
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
    
    func percentageInsideProx(maxDistance: Distance, range: Range<Distance>, lie: [Lie], shotType: ShotType) -> Double? {
        let value = self
            .filter { $0.type == shotType }
            .filter { lie.contains($0.startPosition.lie) }
            .filter { range.contains($0.startPosition.yardage) }
            .map { $0.endPosition.yardage }
            .map { return $0 <= maxDistance ? 1 : 0 }
        
        return value.average()
        
    }
    
    func percentageInsideProx(maxDistance: Distance, shotType: ShotType) -> Double? {
        let value = self
            .filter { $0.type == shotType }
            .map { $0.endPosition.yardage }
            .map { return $0 <= maxDistance ? 1 : 0 }
        
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
    
    func percentageEndingIn(lies: [Lie], shotType: ShotType) -> Double? {
        self.filter { $0.type == shotType }
            .map { lies.contains($0.endPosition.lie) && !$0.includesPenalty ? 1 : 0}
            .average()
    }
    
    func percentageLostBall(shotType: ShotType) -> Double? {
        self.filter { $0.type == shotType }
            .map { $0.includesPenalty ? 1 : 0 }
            .average()
    }
    
    
    
    
    
    func strokesGained(_ filter: @escaping (Shot) -> Bool) -> Double {
        //Note that the optional value should never be reached for any complete round.
        self.filter(filter)
            .map { $0.strokesGained ?? 0 }
            .sum()
    }
    
}

extension Array where Element == Round {
    func greensInReg() -> (Int, Int) {
        self.map { $0.getGreens() }.reduce((0, 0)) { partialResult, newData in
            return (partialResult.0 + newData.0, partialResult.1 + newData.1)
        }
    }
    
    func upAndDowns() -> (Int, Int) {
        self.map { $0.holes }
            .flatten()
            .map { $0.upAndDowns }
            .flatten().map { ($0 ? 1 : 0, 1) }
            .reduce((0, 0)) { partialResult, newData in
                return (partialResult.0 + newData.0, partialResult.1 + newData.1)
            }
    }
    
    func birdies() -> Int {
        self.map { $0.birdies }.sum()
    }
    
    func eaglesOrBetter() -> Int {
        self.map { $0.eaglesOrBetter }.sum()
    }
    
    func pars() -> Int {
        self.map { $0.pars }.sum()
    }
    
    func bogeys() -> Int {
        self.map { $0.bogeys }.sum()
    }
    
    func doubleBogeysOrWorse() -> Int {
        self.map { $0.doubleBogeysOrWorse }.sum()
    }
    
    func numberOfHoles() -> Int {
        self.map { $0.holes.count }.sum()
    }
    
    func bounceBack() -> (Int, Int) {
        var successAndTotal = (0, 0)
        
        self.forEach { round in
            var index = 0
            
            while index < round.holes.count - 1 {
                if round.holes[index].scoreToPar > 0 {
                    // only if the next hole is a birdie or better does it count as a bounce back.
                    if round.holes[index + 1].scoreToPar < 0 {
                        successAndTotal.0 += 1
                    }
                    // either way it count as a oppurinity.
                    successAndTotal.1 += 1
                }
                index += 1
            }
        }
        
        return successAndTotal
    }
    
    func scoringAverage() -> Double? {
        self.map { $0.roundScore }.average()
    }
    
    func frontNineScoringAverage() -> Double? {
        self.map { $0.frontNineScore }.average()
    }
    
    func backNineScoringAverage() -> Double? {
        self.map { $0.backNineScore}.average()
    }
    
    func puttsAverage() -> Double? {
        self.map { $0.putts() }.average()
    }
    
    func parScoringAverage(par: Int) -> (Double?, Int) {
        let scoreMap = self.map { $0.holes }
            .flatten()
            .filter { $0.holeData.par == par }
            .map { $0.score }
            
        return (scoreMap.average(), scoreMap.count)
    }
    
    func birdieStreak() -> Int {
        var longStreak = 0
        
        self.forEach { round in
            var tempCounter = 0
            for score in round.holes.map({ $0.scoreToPar }) {
                if score < 0 {
                    tempCounter += 1
                } else {
                    tempCounter = 0
                }
                
                if tempCounter > longStreak {
                    longStreak = tempCounter
                }
            }
        }
        
        return longStreak
    }
    
    func bogeyStreak() -> Int {
        var longStreak = 0
        
        self.forEach { round in
            var tempCounter = 0
            for score in round.holes.map({ $0.scoreToPar }) {
                if score > 0 {
                    tempCounter += 1
                } else {
                    tempCounter = 0
                }
                
                if tempCounter > longStreak {
                    longStreak = tempCounter
                }
            }
        }
        
        return longStreak
    }
    
    func twoChipOccurances() -> (Int, Int) {
        do {
            var successAndFailuresCounter = (0, 0)
            
            try self.map { $0.holes }
                .flatten()
                .map { try $0.getSimplifiedShots() }
                .forEach { holeData in
                    let numberOfChips = holeData.filter { $0.type == .chip_pitch}.count
                    
                    if numberOfChips > 1 {
                        successAndFailuresCounter.0 += 1
                    }
                    
                    if numberOfChips >= 1 {
                        successAndFailuresCounter.1 += 1
                    }
                }
            
            return successAndFailuresCounter
        } catch {
            return (0, 0)
        }
    }
    
    func openShotPercentage() -> (Int, Int) {
        do {
            var successAndFailure = (0, 0)
            try self.map { $0.holes }
                .flatten()
                .filter { $0.holeData.par == 4 }
                .map { try $0.getSimplifiedShots() }
                .forEach { shotList in
                    if !shotList[0].includesPenalty && shotList[1].type == .approach {
                        successAndFailure.0 += 1
                    }
                    
                    successAndFailure.1 += 1
                }
            
            return successAndFailure
        } catch {
            return (0, 0)
        }
    }
    
    func averageDrivingDistance() -> (Distance?, Int) {
        do {
            let yardages = try self.map { $0.holes }
                .flatten()
                .map { try $0.getSimplifiedShots() }
                .flatten()
                .filter(ShotFilters.allTeeShots)
                .map { $0.advancementYardage }
            
            return (yardages.average(), yardages.count)
        } catch {
            return (Distance.zero, 0)
        }
            
    }
    
    func penaltyPercentage() -> (Double?, Int) {
        do {
            let shots = try self.map { $0.holes }
                .flatten()
                .map { try $0.getSimplifiedShots() }
                .flatten()
                .filter(ShotFilters.allTeeShots)
            
            return (shots.percentageLostBall(shotType: .drive), shots.count)
        } catch {
            return (0, 0)
        }
    }
    
    func treePercentage() -> (Double?, Int) {
        do {
            let shots = try self.map { $0.holes }
                .flatten()
                .map { try $0.getSimplifiedShots() }
                .flatten()
                .filter(ShotFilters.allTeeShots)
                
            
            return (shots.percentageEndingIn(lies: [.recovery], shotType: .drive), shots.filter(ShotFilters.allTeeShots).count)
        } catch {
            return (0, 0)
        }
    }
    
    func fairways() -> (Int, Int) {
        self.map { $0.fairways() }
            .reduce((0, 0)) { partialResult, newData in
                return (partialResult.0 + newData.0, partialResult.1 + newData.1)
            }
    }
    
    func strokesGained(for type: ShotType) -> (Double, Int, Int) {
        do {
            let shots = try self
                .map { $0.holes }
                .flatten()
                .map { try $0.getSimplifiedShots() }
                .flatten()
            
            return (shots.strokesGained { $0.type == type }, shots.filter { $0.type == type }.count, self.count)
                
                
            
        } catch {
            preconditionFailure("This function should not be called when the round is not completed")
            return (0, 0, 0)
        }
    }
    
    func saves(filter: @escaping (Shot) -> Bool) -> (Int, Int) {
        do {
            let holeShots = try self.map { $0.holes }
                .flatten()
                .map { try $0.getSimplifiedShots() }
            
            var sandSaveList = [Bool]()
            
            holeShots.forEach { shots in
                var index = 0
                
                while index < shots.count {
                    if filter(shots[index]) {
                        // first we see if there was a hole out. If there was then that means the up and down was succseseful.
                        if index + 1 == shots.count {
                            sandSaveList.append(true)
                            break
                        }
                        // then we check to see if the green was hit on the chip. If it was not then we must add a false and continue our search for more up and downs.
                        if shots[index].endPosition.lie == .green {
                            if shots.count == index + 2 {
                                sandSaveList.append(true)
                                break
                            }
                        }
                        
                        sandSaveList.append(false)
                    }
                    index += 1
                }
            }
            
            return (sandSaveList.filter { $0 }.count, sandSaveList.count)
            
            
        } catch {
            fatalError()
        }
    }
    
    func saves(for lies: [Lie]) -> (Int, Int) {
        do {
            let holeShots = try self.map { $0.holes }
                .flatten()
                .map { try $0.getSimplifiedShots() }
            
            var sandSaveList = [Bool]()
            
            holeShots.forEach { shots in
                var index = 0
                
                while index < shots.count {
                    if shots[index].type == .chip_pitch && lies.contains(shots[index].startPosition.lie) {
                        // first we see if there was a hole out. If there was then that means the up and down was succseseful.
                        if index + 1 == shots.count {
                            sandSaveList.append(true)
                            break
                        }
                        // then we check to see if the green was hit on the chip. If it was not then we must add a false and continue our search for more up and downs.
                        if shots[index].endPosition.lie == .green {
                            if shots.count == index + 2 {
                                sandSaveList.append(true)
                                break
                            }
                        }
                        
                        sandSaveList.append(false)
                    }
                    index += 1
                }
            }
            
            return (sandSaveList.filter { $0 }.count, sandSaveList.count)
            
            
        } catch {
            fatalError()
        }
    }
    
    
    func strokesToHoleOut(_ filter: (Shot) -> Bool) -> (Double?, Int) {
        do {
            var totalStrokes = [Int]()
            try self.map { $0.holes }
                .flatten()
                .map { try $0.getSimplifiedShots() }
                .forEach { shots in
                    if let index = shots.firstIndex(where: { filter($0) }) {
                        totalStrokes.append(shots.count - index)
                        
                    }
                }
            
            return (totalStrokes.average(), totalStrokes.count)
        } catch {
            fatalError()
        }
    }
    
    func threePuttOccurance(_ filter: (Shot) -> Bool) -> (Int, Int) {
        do {
            var totalStrokes = [Int]()
            try self.map { $0.holes }
                .flatten()
                .map { try $0.getSimplifiedShots() }
                .forEach { shots in
                    if let index = shots.firstIndex(where: { filter($0) }) {
                        totalStrokes.append(shots.count - index)
                        
                    }
                }
            
            return (totalStrokes.filter { $0 >= 3 }.count, totalStrokes.count)
        } catch {
            fatalError()
        }
    }
    
    
    
    
}


extension Array where Element: AdditiveArithmetic {
    func sum() -> Element {
        self.reduce(Element.zero) { partialResult, newData in
            return partialResult + newData
        }
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


