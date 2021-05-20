//
//  AddInstructionCell.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/17/21.
//

import UIKit

protocol AddInstructionCellDelegate {
    func addInstruction(description: String, sender: Any)
}

class AddInstructionCell: UITableViewCell {
    
    var delegate: AddInstructionCellDelegate?

    @IBOutlet weak var descriptionTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addInstruction(_ sender: UIButton) {
        delegate?.addInstruction(description: descriptionTextField.text!, sender: self)
        descriptionTextField.text = ""
    }
}
