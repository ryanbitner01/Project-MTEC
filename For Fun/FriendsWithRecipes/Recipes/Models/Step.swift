//
//  instruction.swift
//  Recipes
//
//  Created by Ryan Bitner on 4/20/21.
//

import Foundation

class Step: Codable {
    var order: Int
    var description: String
    
    init(order: Int, description: String) {
        self.order = order
        self.description = description
    }
}
