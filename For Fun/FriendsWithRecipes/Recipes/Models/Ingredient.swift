//
//  Ingredient.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/1/21.
//

import Foundation

class Ingredient: Codable {
    var name: String
    var unit: String?
    var quantity: String?
    var partQuantity: String?
    var count: Int
    
    init(name: String, unit: String? = nil, quantity: String? = nil, partQuantity: String? = nil, count: Int) {
        self.name = name
        self.unit = unit
        self.quantity = quantity
        self.partQuantity = partQuantity
        self.count = count
    }
}
