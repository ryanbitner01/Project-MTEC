//
//  StepCell.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/1/21.
//

import UIKit

class StepCell: UITableViewCell {

    @IBOutlet weak var stepImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
