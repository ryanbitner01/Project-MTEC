//
//  Ingredient.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/1/21.
//

import Foundation

struct Ingredient: Codable {
    var name: String
    var unit: String?
    var quantity: String?
    var partQuantity: String?
    var count: Int
}
