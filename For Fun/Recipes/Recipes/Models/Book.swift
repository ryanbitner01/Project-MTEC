//
//  Book.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/5/21.
//

import Foundation
import Firebase

class Book: Codable {
    
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
    
    var name: String
    var image: Data?
    var imageURL: String?
    var bookColor: String
    var id: UUID
    var recipes: [Recipe]
    var sharedUsers: [String]
    var isShared: Bool
    var owner: String
    
    var documentReference: DocumentReference? {
        guard let path = getPath(path: .album, email: owner) else {return nil}
        return path.document(id.uuidString)
    }
    
    init(name: String, id: UUID = UUID(), recipes: [Recipe] = [], image: Data? = nil, imageURL: String = "", bookColor: String = "Blue",sharedUsers: [String] = [], isShared: Bool = false, owner: String = "" ) {
        self.recipes = recipes
        self.id = id
        self.name = name
        self.image = image
        self.imageURL = imageURL
        self.bookColor = bookColor
        self.sharedUsers = sharedUsers
        self.isShared = isShared
        self.owner = owner
    }
}
