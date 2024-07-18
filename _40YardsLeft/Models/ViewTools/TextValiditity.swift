//
//  TextValiditity.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-18.
//

import Foundation
import SwiftUI

/// A struct used to contain all the error checking mechanisms for
struct TextValiditity {

  /// A password validitity checker used to ensure that user passwords are valid
  static let passwordCheck: (String) -> [String] = { password in
    var errorList = [String]()

    if password.count <= 7 {
      errorList.append("Must be Longer than 7 Characters")
    } else {
      if password.contains(" ") {
        errorList.append("Must not Contain Spaces")
      }

      if !password.contains(try! Regex("[^A-Za-z0-9]+")) {
        errorList.append("Must Contain One Special Character")
      }

      if !password.contains(try! Regex("[A-Z]+")) {
        errorList.append("Must Contain One Capital Letter")
      }

      if !password.contains(try! Regex("[a-z]+")) {
        errorList.append("Must Contain One Lowercase Letter")
      }

      if !password.contains(try! Regex("[0-9]+")) {
        errorList.append("Must Contain One at Least 1 Number")
      }
    }

    return errorList

  }

  /// A text checker which ensures that the provided email address is valid
  static let emailChecker: (String) -> [String] = { entry in
    var errorList = [String]()

    if !entry.contains(
      try! Regex(
        "^[\\w!#$%&'*+/=?`{|}~^-]+(?:\\.[\\w!#$%&'*+/=?`{|}~^-]+)*@(?:[A-z0-9-]+\\.)+[A-z]{2,6}$"
      ))
    {
      errorList.append("Invalid Email Address")
    }

    return errorList

  }

  ///An example condition used to ensure that the entry is not empty
  static let mustNotBeEmptyCondition: (String) -> [String] = { value in
    if value.isEmpty {
      return ["Must Not Be Empty"]
    }

    return []
  }

  /// Combines a given set of text checkers using an AND operator
  ///
  /// - Note: There is no checking completed on the provided conditions. If they conflict and cover inverse areas of the solution space then it will result in a condition
  ///
  /// - Parameter conditions: The condtions you would like to combine
  /// - Returns: A condition statement which which combines all provided entries provided such that it combines all outputs into one.
  static func combine(conditions: [(String) -> [String]]) -> (String) -> [String] {
    return { newString in
      let stringList = conditions.map { $0(newString) }
      return Array.combine(arrays: stringList)
    }
  }

  /// A text checker which checks if the given text is identical to the provided parameter.
  ///
  /// - Parameter text: The text which you would like to ensure thew provided text is not equal to it.
  /// - Returns: A condition statment which shows the element duplicate text if the text is the same as the provided parameter
  static func mustNotBeEqualTo(_ text: String) -> (String) -> [String] {
    return { newString in
      return newString == text ? ["Duplicate Text"] : []
    }
  }

  /// A text checker which ensures that the length of the string in within the provided range.
  ///
  /// The checker will only trigger errors if the value is the text length is outside the provided range.
  /// - Parameter range: A range statment containg all allowable lengths of the text.
  /// - Returns: A condition statement which identifies the the missed condition.
  static func betweenSizes(range: Range<Int>) -> (String) -> [String] {
    return { newValue in
      if newValue.count < range.lowerBound {
        return ["Must contain \(range.lowerBound) characters"]
      }

      if newValue.count > range.upperBound {
        return ["Must contain less than \(range.upperBound) characters"]
      }
      return []
    }
  }

  /// A text checker used to confirm that a (Double) value is within the provided range
  /// - Parameter range: <#range description#>
  /// - Returns: <#description#>
  static func valueOfNumberWithin(range: Range<Double>) -> (String) -> [String] {
    return { newValue in
      if let numericalValue = Double(newValue) {
        if !range.contains(numericalValue) {
          return [
            "Must be within " + range.lowerBound.toDecimalPlaces(0) + " and "
              + range.upperBound.toDecimalPlaces(0)
          ]
        }
        return []
      } else {
        return ["Must be a number"]
      }
    }
  }

}

extension Double {

  /// Gets the string of a decimal to a certain number of decimal places
  ///
  /// - Parameter numberOfDecimalPlaces: The number of decimal places you would like to get your number to
  /// - Returns: A string containing the number with the number decimal places provided
  func toDecimalPlaces(_ numberOfDecimalPlaces: Int) -> String {
    return String(format: "%.\(numberOfDecimalPlaces)f", self)
  }
}

extension Formatter {
  static var wholeNumber: Formatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .none
    return formatter
  }
  static func decimal(numOfDigits: Int) -> Formatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = numOfDigits
    return formatter
  }
}
