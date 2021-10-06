//
//  Book.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/5/21.
//

import Foundation
import Firebase

protocol BookProtocol {
    var name: String { get set }
    var imageURL: String? { get set }
    var bookColor: String { get set }
    var id: UUID { get set }
    var owner: String { get set }

}

class Book: Codable, BookProtocol {
    
    var name: String
    var imageURL: String?
    var bookColor: String
    var id: UUID
    var sharedUsers: [String]
    var isShared: Bool
    var owner: String
    var image: Data?
    var recipes: [Recipe]
    
    init(name: String, id: UUID = UUID(), imageURL: String = "", bookColor: String = "Blue",sharedUsers: [String] = [], isShared: Bool = false, owner: String = "", image: Data? = nil, recipes: [Recipe] = []) {
        self.id = id
        self.name = name
        self.image = image
        self.imageURL = imageURL
        self.bookColor = bookColor
        self.sharedUsers = sharedUsers
        self.isShared = isShared
        self.owner = owner
        self.recipes = recipes
    }
}

class BookCover: Codable, BookProtocol {
    
    var name: String
    var imageURL: String?
    var bookColor: String
    var id: UUID
    var owner: String
    
    init(name: String, id: UUID = UUID(), imageURL: String = "", bookColor: String = "Blue", owner: String = "") {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.bookColor = bookColor
        self.owner = owner
    }
}
