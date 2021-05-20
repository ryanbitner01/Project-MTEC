//
//  StepCell.swift
//  Recipe Prototype
//
//  Created by Ryan Bitner on 5/20/21.
//

import UIKit

class StepCellEdit: UITableViewCell {

    @IBOutlet weak var stepImageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
