//
//  SharingController.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/22/21.
//

import Foundation

enum SharingError: Error {
    case duplicateUser
    case selfUser
    case userDoesNotExist
}

extension SharingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .duplicateUser:
            return "Already shared with this user"
        case .selfUser:
            return "This user is your self"
        case .userDoesNotExist:
            return "This user is not found, check your spelling."
        }
    }
}

class SharingController {
    
    
    
    static let shared = SharingController()
    
    private init() {
        
    }
    
    func canShare(book: Book, email: String, completion: @escaping (SharingError?) -> Void) {
        if checkDuplicateUser(book: book, email: email) {
            completion(.duplicateUser)
        } else if checkForSameEmail(book: book, email: email) {
            completion(.selfUser)
        } else {
            userExists(email: email) { err in
                if let err = err {
                    completion(err)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func checkDuplicateUser(book: Book, email: String) -> Bool {
        if book.sharedUsers.contains(email) {
            return true
        } else {
            return false
        }
    }
    
    func checkForSameEmail(book: Book, email: String) -> Bool{
        if book.owner == email {
            return true
        } else {
            return false
        }
    }
    
    func userExists(email: String, completion: @escaping (SharingError?) -> Void) {
        let docRef = db.collection("Users").document(email)
        docRef.getDocument { doc, err in
            if let doc = doc, doc.exists {
                completion(nil)
            } else if let err = err{
                print(err.localizedDescription)
                completion(.userDoesNotExist)
            } else {
                completion(nil)
            }
        }
    }
}
