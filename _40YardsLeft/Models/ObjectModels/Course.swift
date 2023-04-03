//
//  Course.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-25.
//

import Foundation

//MARK: Course Struct
struct Course : Codable, Equatable, Identifiable {
    private(set) var listOfTees: [Tee]
    var location: Address
    var name: String
    let id: UUID
    
    init(listOfTees: [Tee], location: Address, name: String) {
        self.listOfTees = listOfTees
        self.location = location
        self.name = name
        self.id = UUID()
    }
    
    init(location: Address, name: String) {
            self.init(listOfTees: [], location: location, name: name)
        
    }
    
    @discardableResult
    /// Adds a new tee to this course
    /// - Parameter tee: A tee to be added
    /// - Returns: True if this tee was added succsefully exists, false if the tee has already been added.
    mutating func addTee(_ tee: Tee) -> Bool {
        if listOfTees.contains(tee) {
            return false
        }
        
        listOfTees.append(tee)
        return true
    }
    
    
    func hasTee(_ tee: Tee) -> Bool {
        return listOfTees.contains(tee)
    }
    
}

extension Course: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        _ = hasher.finalize()
    }
}

//MARK: Course Extension
extension Course {
    static let example1: Course = {
        var course = Course(location: .example1, name: "Beacon Slopes")
        
        let dataList: [(Distance, Int, Int)] = [
            //start of front nine
            (.yards(490), 2, 4),
            (.yards(340), 18, 4),
            (.yards(134), 16, 3),
            (.yards(560), 8, 5),
            (.yards(347), 12, 4),
            (.yards(221), 4, 3),
            (.yards(590), 6, 5),
            (.yards(389), 14, 4),
            (.yards(428), 10, 4),
            //start of back nine
            (.yards(423), 9, 4),
            (.yards(457), 3, 4),
            (.yards(521), 15, 5),
            (.yards(201), 1, 3),
            (.yards(401), 11, 4),
            (.yards(621), 5, 5),
            (.yards(304), 17, 4),
            (.yards(154), 13, 3),
            (.yards(469), 7, 3)
        ]
        let holeData = HoleData.massEntry(data: dataList)
        
        let myTee = try! Tee(rating: 73.8, slope: 123, holeData: holeData, name: "Black")
        
        course.listOfTees.append(myTee)
        
        return course
    }()
}



//MARK: Address Struct
struct Address : Codable, Equatable {
    let addressLine1: String
    let city: String
    let province: Province
    let country: Country
    
    
    
}

enum Province: String, CaseIterable, Codable {
    case BC = "British Columbia"
    case AB = "Alberta"
    //TODO: complete this list
}

enum Country: String, CaseIterable, Codable {
    case Canada = "Canada"
    case US = "United States"
}

extension Country: Identifiable {
    var id: Self { self }
}

//MARK: Address extension
extension Address {
    static let example1 = Address(addressLine1: "4679 York Ave.", city: "West Vancouver", province: .BC, country: .Canada)
    
}


//MARK: Tee Struct
struct Tee : Codable, Equatable, Hashable, Identifiable {
    var rating: Double
    var slope: Int
    var holeData: [HoleData]
    var name: String
    let id: UUID
    
    
    /// Creates a new instance of a tee
    ///
    /// - Warning: There are many important preconditions to be met when instantiating a tee object, please be mindful of them
    ///
    /// - Throws: `inavlidSlope` when the slope is invalid
    /// - Throws: `inavlidRating` when the rating is invalid
    /// - Throws: `tooManyHoles` when the number of holes provided is larger than 18
    /// - Throws: `inavlidHandicap` when the handicaps are not entered correctly, either there are duplicates or there is values which are not between 1 and 18.
    ///
    /// - Parameters:
    ///   - rating: The rating of this tee which must be greater than 0
    ///   - slope: The slope of this tee which must satisfy: 55 <= slope <= 155
    ///   - holeData: The list of holeData which this tee comntains. All handicaps must be unqiue and must be of values between 1 and 18.
    init(rating: Double, slope: Int, holeData: [HoleData], name: String) throws {
        self.rating = rating
        self.slope = slope
        self.holeData = holeData
        self.name = name
        self.id = UUID()
        
        
        try self.isHoleDataValid()
        
    }
    
    @discardableResult
    /// Checks to see if this tee is valid.
    ///
    /// - Note: This can be used as a rep invariant check of datatype as well as a check on entry
    ///
    /// A valid tee must meet the following conditions.
    /// - The tee must not contain more than 18 entries of hole data
    /// - The handicaps of the holes must not have duplicates (i.e. 2 holes must not have the same handicap)
    /// - The slope must valid (55 <= Slope <= 155)
    /// - The rating of the course must be greater than 0.
    ///
    /// - Throws: `inavlidSlope` when the slope is invalid
    /// - Throws: `inavlidRating` when the rating is invalid
    /// - Throws: `tooManyHoles` when the number of holes provided is larger than 18
    /// - Throws: `inavlidHandicap` when the handicaps are not entered correctly, either there are duplicates or there is values which are not between 1 and 18.
    ///
    /// - Parameter tee: The tee you would like to see if it is valid.
    /// - Returns: True if the course is valid, false otherwise.
    private func isHoleDataValid() throws -> Bool {
        if self.slope < 55 || self.slope > 155 {
            throw TeeError.invalidSlope
        }
        
        if self.rating < 0 {
            throw TeeError.invalidRating
        }
        
        if self.holeData.count > 18 {
            throw TeeError.tooManyHoles
        }
        
        if !self.holeData
            .map({ $0.handicap })
            .isUnique {
            throw TeeError.invalidHandicaps
        }
        
        if !self.holeData
            .map({ $0.handicap })
            .filter({ $0 < 1 || $0 > 18})
            .isEmpty {
            throw TeeError.invalidHandicaps
        }
        
        // all cases return true if no errors are present. 
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        _ = hasher.finalize()
    }
    
    
}

extension Tee {
    /// The yardage of this teebox
    var yardage: Int {
        self.holeData.reduce(0) { partialResult, data in
            return partialResult + Int(data.yardage.yardage)
        }
    }
    
    var par: Int {
        self.holeData.reduce(0) { partialResult, data in
            return partialResult + data.par
        }
    }
}

//MARK: Array extension
extension Array where Element: Hashable {
    
    var isUnique: Bool {
        var seen = Set<Element>()
        return allSatisfy { seen.insert($0).inserted }
    }

    
}

//MARK: Tee Error
enum TeeError : Error {
    case invalidSlope
    case invalidRating
    case tooManyHoles
    case invalidHandicaps
}


//MARK: Hole Data Struct
struct HoleData: Codable, Equatable, Identifiable {
    
    let id: UUID
    
    /// The yardage pf the hole which must not be negative
    var yardage: Distance
    /// The handicap of the hole must be between 1 and 18
    var handicap: Int
    /// The par of the hole, which must not be negative
    var par: Int
    
    
    /// Creates a new instance of HoleData
    ///
    /// - Parameters:
    ///   - yardage: The yardage of the hole
    ///   - handicap: The handicap of the hole
    ///   - par: The par of this hole
    init(yardage: Distance, handicap: Int, par: Int) {
        self.id = UUID()
        self.yardage = yardage
        self.handicap = handicap
        self.par = par
    }
    
    
}


//MARK: HoleData Extension
extension HoleData {
    
    /// Creates a list of Holes
    ///
    /// - Each index of the list corresponds to the data of a single hole
    ///
    /// - Parameter data: A list of tuples which contain the distance of the hole combined with the handicap then par.
    /// - Returns: A list of the same size as the provided input containing holedata.
    static func massEntry(data: [(Distance, Int, Int)]) -> [HoleData] {
        return data.map { HoleData(yardage: $0.0, handicap: $0.1, par: $0.2) }
    }
    
    static let averageHole = HoleData(yardage: .yards(400), handicap: 10, par: 4)
}

