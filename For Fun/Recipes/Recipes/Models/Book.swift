//
//  Book.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/5/21.
//

import Foundation

class Book: Codable {
    var name: String
    var image: Data?
    var imageURL: String?
    var bookColor: String
    var id: UUID
    var recipes: [Recipe]
    var sharedUsers: [String]
    var isShared: Bool
    
    init(name: String, id: UUID = UUID(), recipes: [Recipe] = [], image: Data? = nil, imageURL: String = "", bookColor: String = "Blue",sharedUsers: [String] = [], isShared: Bool = false ) {
        self.recipes = recipes
        self.id = id
        self.name = name
        self.image = image
        self.imageURL = imageURL
        self.bookColor = bookColor
        self.sharedUsers = sharedUsers
        self.isShared = isShared
    }
}
