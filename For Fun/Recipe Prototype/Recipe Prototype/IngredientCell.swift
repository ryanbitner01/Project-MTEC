//
//  IngredientCell.swift
//  Recipe Prototype
//
//  Created by Ryan Bitner on 5/20/21.
//

import UIKit

class IngredientCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
