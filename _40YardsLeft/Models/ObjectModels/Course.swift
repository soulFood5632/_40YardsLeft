//
//  Course.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-25.
//

import Foundation

//MARK: Course Struct
struct Course : Codable, Equatable {
    var listOfTees: [Tee]
    var location: Address
    var name: String
    
}


//MARK: Address Struct
struct Address : Codable, Equatable {
    let addressLine1: String
    let city: String
    let province: String
    let country: String
}


//MARK: Tee Struct
struct Tee : Codable, Equatable {
    var rating: Double
    var slope: Int
    var holeData: [HoleData]
    
}


//MARK: Hole Data Struct
struct HoleData : Codable, Equatable {
    
    /// The yardage pf the hole which must not be negative
    var yardage: Distance
    /// The handicap of the hole must be between 1 and 18
    var handicap: Int
    /// The par of the hole, which must not be negative
    var par: Int
    
}

