//
//  Book.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/5/21.
//

import Foundation

struct Book: Codable {
    var name: String
    var image: Data?
    var imageURL: String?
    var bookColor: String
    var id: UUID
    var recipes: [Recipe]
    
    init(name: String, id: UUID = UUID(), recipes: [Recipe] = [], image: Data? = nil, imageURL: String = " ", bookColor: String = "black") {
        self.recipes = recipes
        self.id = id
        self.name = name
        self.image = image
        self.imageURL = imageURL
        self.bookColor = bookColor
    }
}
