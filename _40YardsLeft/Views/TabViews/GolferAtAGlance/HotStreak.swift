//
//  RoundUpdateView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-13.
//

import SwiftUI

struct HotStreak: View {
    private static let DAYS_IN_PAST = 30
    let golfer: Golfer
    var body: some View {
        
        VStack {
                HStack {
                    Text("\(numberOfRoundsPlayed) rounds in the last \(Self.DAYS_IN_PAST) days")
                    HotOrColdView(isHot: self.isRoundsPlayedHot)
                }
            
            
            
            
            
            
        }
        
    }
}

extension HotStreak {
    /// Gets if the the number of rounds played in the last `Self.DAYS_IN_PAST` is hot or cold
    ///
    ///  - `Hot` is defined as playing 0.1 more rounds per day than average
    ///  - `Cold` is defined as playing 0.1 less rounds per day than average
    ///  - `Mild` is defined as anywhere in the middle
    private var isRoundsPlayedHot: ThreeState {
        return IsHot.numOfRounds(rounds: self.numberOfRoundsPlayed, days: Self.DAYS_IN_PAST, hotThreshold: golfer.roundsPerDay + 0.1, coldThreshold: golfer.roundsPerDay - 0.1)
    }
    
    
    /// The number of rounds played in the last `Self.DAYS_IN_PAST`
    private var numberOfRoundsPlayed: Int {
        golfer.roundsInTheLast(days: Self.DAYS_IN_PAST)
    }
}



extension Golfer {
    
    /// Gets the number of rounds in the last provided days
    /// 
    /// - Parameter days: The number of days in the past you would like to search to.
    /// - Returns: The count of the number of rounds played in the last (X) days
    func roundsInTheLast(days: Int) -> Int {
        let currentTime = Date.now
        return rounds.filter { $0.date > currentTime.jumpDaysAhead(by: -days) }.count
    }
}

extension Date {
    
    /// Gets a new date which is the an interval of days ahead
    ///
    /// - Parameter days: The number of days where the past is positive and future is negative
    /// - Returns: A date which is the original date plus the provided jumping distance
    func jumpDaysAhead(by days: Int) -> Date {
        self.addingTimeInterval(.days(days))
    }
}

extension TimeInterval {
    
    /// Gets a time interval for the number of provided days
    ///
    /// - Parameter days: The number of days you would like a time interval of
    /// - Returns: A time interval of the provided number of days.
    static func days(_ days: Int) -> TimeInterval {
        //seconds /minute * minutes/hour * hours / day * days
        return TimeInterval(60 * 60 * 24 * days)
    }
}

struct RoundUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        HotStreak(golfer: Golfer.golfer)
    }
}
