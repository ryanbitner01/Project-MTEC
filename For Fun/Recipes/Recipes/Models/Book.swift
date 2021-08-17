//
//  Book.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/5/21.
//

import Foundation
import Firebase

class Book: Codable {
    
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
