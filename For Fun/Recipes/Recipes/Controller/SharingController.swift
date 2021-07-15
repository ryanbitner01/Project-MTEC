//
//  SharingController.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/22/21.
//

import Foundation
import Firebase

enum SharingError: Error {
    case duplicateUser
    case selfUser
    case userDoesNotExist
    case noUser
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
        case .noUser:
            return "No user selected."
        }
    }
}

class SharingController {
    
    
    
    static let shared = SharingController()
    
    private init() {
        
    }
    
    func getUserPath() -> CollectionReference? {
        if testingEnabled {
            return db.collection("TestUsers")
        } else {
            return db.collection("Users")
        }
    }
    
    func getPath(path: FireBasePath, email: String?) -> CollectionReference? {
        guard let userPath = getUserPath() else {return nil}
        switch path {
        case .newAlbum:
            if let email = email {
                return userPath.document(email).collection("Album")
            } else {
                return nil
            }
        case .album:
            if let user = UserControllerAuth.shared.user {
                return userPath.document(user.id).collection("Album")
            } else {
                return nil
            }
        case .otherSharedAlbum:
            if let email = email {
                return userPath.document(email).collection("SharedAlbum")
            } else {
                return nil
            }
        case .sharedAlbum:
            if let user = UserControllerAuth.shared.user {
                return userPath.document(user.id).collection("SharedAlbum")
            } else {
                return nil
            }
        }
    }
    
    func sendShareRequest(book: Book, profile: Profile, completion: @escaping (SharingError?) -> Void) {
        
        let owner: [String: Any] = [
            "Name": profile.name,
            "imageURL": profile.imageURL
        ]
        
        let request: [String: Any] = [
            "bookName": book.name,
            "bookImage": book.imageURL ?? "",
            "bookColor": book.bookColor,
            "bookOwner": owner
        ]
        guard let path = getPath(path: .otherSharedAlbum, email: profile.email) else {return}
        // Send Request to other user
        path.document("BookShareRequests").setData([
            "Requests": FieldValue.arrayUnion([request])
        ], mergeFields: [
            "Requests"
        ])
        
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
