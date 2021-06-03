//
//  StepCellEdit.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/3/21.
//

import UIKit

class StepCellEdit: UITableViewCell {

    @IBOutlet weak var stepImageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var step: Step?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell() {
        stepImageView.image = UIImage(systemName: "\(step?.order ?? 0).circle.fill")
        descriptionTextField.text = step?.description
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
