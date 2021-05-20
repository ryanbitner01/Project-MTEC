//
//  Recipe.swift
//  Recipe Prototype
//
//  Created by Ryan Bitner on 5/20/21.
//

import Foundation

struct Recipe {
    var name: String
    var ingredients: [Ingredient]
    var steps: [Step]
    
    static let fakeRecipe = Recipe(
        name: "Vermont White Cheddar Noodles" ,
        ingredients: [
            Ingredient(name: "2 Tbsp Butter", count: 1),
            Ingredient(name: "2 Cups Water", count: 2),
            Ingredient(name: "2/3 Cup Milk", count: 3),
            Ingredient(name: "Seasoning Packet", count: 4)
        ],
        steps: [
            Step(descripton: "In a medium saucepan, bring water and butter to a boil, then add the pasta", count: 1),
            Step(descripton: "Reduce heat to medium, boil uncovered for 12-14 min.", count: 2),
            Step(descripton: "Stir in milk and seasoning packet, return to a boil then cook 1-2 min, let stand for 3-5 min to thicken.", count: 3),
            Step(descripton: "Enjoy!", count: 4)
        ])
}
