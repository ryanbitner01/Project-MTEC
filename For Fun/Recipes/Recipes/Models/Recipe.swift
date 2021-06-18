//
//  Recipe.swift
//  Recipes
//
//  Created by Ryan Bitner on 3/10/21.
//

import Foundation

class Recipe: Codable {
    var id: UUID
    var name: String
    var image: Data?
    var imageURL: String?
    var instruction: [Step]
    var ingredients: [Ingredient]
    
    init(id: UUID = UUID(), name: String, image: Data? = nil, imageURL: String = "", instruction: [Step] = [], ingredients: [Ingredient] = []) {
        self.id = id
        self.name = name
        self.image = image
        self.imageURL = imageURL
        self.instruction = instruction
        self.ingredients = ingredients
    }
    
}
