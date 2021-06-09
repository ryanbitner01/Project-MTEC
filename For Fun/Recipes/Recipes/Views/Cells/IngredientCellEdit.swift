//
//  IngredientCellEdit.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/3/21.
//

import UIKit

protocol IngredientCellEditDelegate {
    func editIngredient(sender: Any)
}

class IngredientCellEdit: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    var ingredient: Ingredient?
    var delegate: IngredientCellEditDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell() {
        guard let ingredient = ingredient else {return}
        let unit = ingredient.unit ?? ""
        let quantity = ingredient.quantity ?? ""
        nameLabel.text = "\(quantity) \(unit) \(ingredient.name)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        delegate?.editIngredient(sender: self)
    }
}
