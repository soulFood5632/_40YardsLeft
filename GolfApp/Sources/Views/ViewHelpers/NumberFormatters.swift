//
//  NumberFormatters.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-27.
//

import Foundation

extension Double {
  func roundToPercent() -> String {
    let roundedValue = (self * 100).rounded() / 100

    return roundedValue.formatted(.percent)
  }
}
