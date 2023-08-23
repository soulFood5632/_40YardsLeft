//
//  DatabaseCommunicator.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-25.
//

import Foundation
import FirebaseFirestore
import FirebaseCore
import Firebase
import FirebaseFirestoreSwift

struct DatabaseCommunicator {
    
    private static let database = Firestore.firestore()
    
    private static let COURSE_POSTING = "CoursesForReview"
    private static let GOLFER_LIST_ID = "GolferList"
    
    static func addGolfer(golfer: Golfer) async throws -> Bool {
        
        try database
            .collection(Self.GOLFER_LIST_ID)
            .document(golfer.firebaseID)
            .setData(from: golfer)
            
        return true
    }
    
    static func addCourse(course: Course) async throws -> Bool {
        //TODO: reassign additions to a review folder.
        try database
            .collection(course.location.province.databaseKey)
            .document(course.name)
            .setData(from: course)
        
        return true
    }
    

    
    static func getGolfer(id: String) async throws -> Golfer {
        let docReference = database.collection(Self.GOLFER_LIST_ID).document(id)
        do {
            return try await docReference.getDocument(as: Golfer.self)
        } catch {
            fatalError(error.localizedDescription.debugDescription)
        }
    }
    
    
    
    static func getCoursesFromFilter(country: Country, provinceState: Province) async throws -> [Course] {
        let id = provinceState.databaseKey
        
        return try await database
            .collection(id)
            .getDocuments()
            .documents
            .map { try $0.data(as: Course.self) }
        
    }
    
    static func getCoursesFromFilter(_ filter: Filters) async throws -> [Course] {
        return try await getCoursesFromFilter(country: filter.country, provinceState: filter.province)
    }
    
    //TODO: think about your data structures. Golfer makes sense but as for the courses i dont extacly but this as the best method.
    
    
}

enum EncoderError : String, Error {
    case failedToConvertToDictonary = "Data was not storable"
}

enum QueryError: Error {
    case invalidCountryProvinceCombo
}
