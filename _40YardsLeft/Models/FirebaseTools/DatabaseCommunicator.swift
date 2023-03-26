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
    
    private static let COURSE_COLLECTION_ID = "CourseList"
    private static let GOLFER_LIST_ID = "GolferList"
    
    static func addGolfer(golfer: Golfer) async throws -> Bool {
        
        try database.collection(Self.GOLFER_LIST_ID).document(golfer.firebaseID).setData(from: golfer)
            
        return true
        
        
        
    }
    
    static func addCourse(course: Course) async throws -> Bool {
        try database.collection(Self.COURSE_COLLECTION_ID).document(course.name).setData(from: course)
        
        return true
    }
    
    static func getGolfer(id: String) async throws -> Golfer {
        let docReference = database.collection(Self.GOLFER_LIST_ID).document(id)
        
        return try await docReference.getDocument(as: Golfer.self)
    }
    
    static func getCourses() async throws -> [Course] {
        return try await database
            .collection(Self.COURSE_COLLECTION_ID)
            .getDocuments()
            .documents
            .map { document in
                try document.data(as: Course.self)
            }
        
    }
    
    //TODO: think about your data structures. Golfer makes sense but as for the courses i dont extacly but this as the best method.
    
    
}

enum EncoderError : String, Error {
    case failedToConvertToDictonary = "Data was not storable"
    
}
