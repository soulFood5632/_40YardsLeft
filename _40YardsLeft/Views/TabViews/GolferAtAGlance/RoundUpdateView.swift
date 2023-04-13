//
//  RoundUpdateView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-13.
//

import SwiftUI

struct RoundUpdateView: View {
    let golfer: Golfer
    var body: some View {
        GroupBox {
            let daysInPast = 30
            let rounds = golfer.roundsInTheLast(days: daysInPast)
            HStack {
                Text("\(rounds) rounds in the last \(daysInPast) days")
                HotOrColdView(isHot: true)
            }
        }
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
        RoundUpdateView(golfer: Golfer.golfer)
    }
}
