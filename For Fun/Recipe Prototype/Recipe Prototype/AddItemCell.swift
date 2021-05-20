//
//  AddItemCell.swift
//  Recipe Prototype
//
//  Created by Ryan Bitner on 5/20/21.
//

import UIKit

protocol AddItemCellDelegate {
    func addItem(text: String, sender: Any)
}

class AddItemCell: UITableViewCell {
    
    enum itemType {
        case ingredient
        case step
    }

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var delegate: AddItemCellDelegate?
    var itemType: itemType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addItem(_ sender: Any) {
        delegate?.addItem(text: descriptionTextField.text!, sender: self)
    }
}
