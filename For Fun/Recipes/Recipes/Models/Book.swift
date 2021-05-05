//
//  Book.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/5/21.
//

import Foundation

struct Book: Codable {
    var recipes: [Recipe]
    
    init(recipes: [Recipe] = []) {
        self.recipes = recipes
    }
}
