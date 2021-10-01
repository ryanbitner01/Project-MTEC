//
//  MigrationController.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/23/21.
//

import Foundation
import Firebase

let testingEnabled = true

enum MigrationError: Error {
    case passwordChange
    case nameChange
    case invalidName
}

extension MigrationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .passwordChange:
            return "The password could not be changed, please try again."
        case .nameChange:
            return "The name could not be changed, either because the name has already been used or an uknown error has occured."
        case .invalidName:
            return "The name is already in use, please choose a different name."
        }
    }
}

class MigrationController {
    
    static let shared = MigrationController()
    
    var oldAlbum = [Book]()
    
    private init() {
        
    }
    
    func getUserPath() -> CollectionReference? {
        if testingEnabled {
            return db.collection("TestUsers")
        } else {
            return db.collection("Users")
        }
    }
    
    //MARK: Email Change
    // Changes the document in firestore associated with the email
    
    func changeName(new: String, completion: (MigrationError?) -> Void) {
        guard let path = getUserPath(), let user = UserControllerAuth.shared.user else {return completion(.nameChange)}
        completion(nil)
        path.document(user.id).updateData([
            "DisplayName": new
        ])
        
    }
    
    //MARK: Password Change
    // Changes the password in Authentication
    
    func changePassword(new: String, completion: @escaping (MigrationError?) -> Void) {
        auth.currentUser?.updatePassword(to: new, completion: { err in
            if let err = err {
                print(err.localizedDescription)
                completion(.passwordChange)
            } else {
                completion(nil)
            }
        })
    }
}
