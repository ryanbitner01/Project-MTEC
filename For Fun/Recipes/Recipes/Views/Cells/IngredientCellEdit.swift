//
//  IngredientCellEdit.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/3/21.
//

import UIKit

class IngredientCellEdit: UITableViewCell {

    @IBOutlet weak var nameTextField: UITextField!
    
    var ingredient: Ingredient?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell() {
        nameTextField.text = ingredient?.name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
