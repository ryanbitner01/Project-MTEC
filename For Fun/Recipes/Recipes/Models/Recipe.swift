//
//  Recipe.swift
//  Recipes
//
//  Created by Ryan Bitner on 3/10/21.
//

import Foundation

struct Recipe: Codable {
    var name: String
    var image: Data?
    var instruction: [Instruction]
    
    static var recipes = [Recipe]()
}
