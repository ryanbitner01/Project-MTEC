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
        recipeLabel.layer.borderColor = UIColor(named: "tintColor")?.cgColor
        recipeLabel.layer.borderWidth = 2
        recipeLabel.layer.cornerRadius = 10

    }
    
    func setupImageView() {
        guard let recipe = recipe else {return}
        if let image = recipe.imageURL {
            RecipeController.shared.getRecipeImage(url: image) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.recipeImageView.image = image
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        }
    }
    
}
