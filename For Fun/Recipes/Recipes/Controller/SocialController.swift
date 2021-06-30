//
//  SocialController.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/30/21.
//

import Foundation
import Firebase

enum SocialError: Error {
    case friendRequestErr
    case friendAccept
    case noEmail
    case noProfile
    case otherErr
}

extension SocialError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .friendRequestErr:
            return "Unable to complete friend request"
        case .friendAccept:
            return "Unable to accept friend request"
        case .noEmail:
            return "Unable to find a email for this user"
        case .noProfile:
            return "No profile Found"
        case .otherErr:
            return "Other Error"
        }
    }
}

class SocialController {
    
    //MARK: Properties
    static let shared = SocialController()
    
    private init() {
        
    }
    
    func getUserPath() -> CollectionReference? {
        if testingEnabled {
            return db.collection("TestUsers")
        } else {
            return db.collection("Users")
        }
    }
    
    func sendFriendRequest(user: String, completion: @escaping (SocialError?) -> Void) {
        guard let path = getUserPath() else {return completion(.friendRequestErr)}
        let otherUser = path.document(user)
        otherUser.updateData([
            "PendingFriends": FieldValue.arrayUnion([user])
        ]) { err in
            if err != nil {
                completion(.friendRequestErr)
            } else {
                completion(nil)
            }
        }
        completion(nil)
    }
    
    func acceptRequest(otherUser: String, completion: @escaping (SocialError?)-> Void) {
        guard let path = getUserPath(), let user = UserControllerAuth.shared.user else {return completion(.friendAccept)}
        let otherUserPath = path.document(otherUser)
        let userPath = path.document(user.id)
        // Add new friend to your own user
        userPath.updateData([
            "Friends": FieldValue.arrayUnion([otherUser]),
            "PendingFriends": FieldValue.arrayRemove([otherUser])
        ]) {err in
            if err != nil {
                completion(.friendAccept)
            } else {
                completion(nil)
            }
        }
        otherUserPath.updateData([
            "Friends": FieldValue.arrayUnion([user.id]),
            "PendingFriends": FieldValue.arrayRemove([user.id])
        ]) { err in
            if err != nil {
                completion(.friendAccept)
            } else {
                completion(nil)
            }
        }
    }
    
    func getEmailFromDisplayName(displayName: String, completion: @escaping (Result<String, SocialError>)-> Void) {
        guard let userPath = getUserPath() else {return completion(.failure(.noEmail))}
        let query = userPath.whereField("DisplayName", isEqualTo: displayName)
        query.getDocuments { docs, err in
            let emails = docs?.documents.compactMap({ doc -> String? in
                let email = doc.documentID
                return email
            })
            if let email = emails?.first(where: {$0 == displayName}) {
                completion(.success(email))
            } else {
                completion(.failure(.noEmail))
            }
        }
    }
    
    func getProfileFromEmail(email: String, completion: @escaping (Result<Profile, SocialError>) -> Void) {
        guard let path = getUserPath() else {return completion(.failure(.noProfile))}
        path.document(email).getDocument { doc, err in
            if let doc = doc {
                guard let data = doc.data(), let name = data["DisplayName"] as? String else {return completion(.failure(.noProfile))}
                let profile = Profile(name: name)
                completion(.success(profile))
            } else if err != nil {
                completion(.failure(.noProfile))
            } else {
                completion(.failure(.otherErr))
            }
        }
    }
    
}
