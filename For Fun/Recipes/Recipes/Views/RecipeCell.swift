//
//  RecipeCell.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/11/21.
//

import UIKit

class RecipeCell: UICollectionViewCell {
    
    var recipe: Recipe?
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeLabel: UILabel!
    
    func updateCell() {
        setupImageView()
        recipeLabel.text = recipe?.name
    }
    
    func setupImageView() {
        
    }
    
}
