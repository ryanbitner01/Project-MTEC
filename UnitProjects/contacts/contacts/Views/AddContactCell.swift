//
//  AddContactCell.swift
//  contacts
//
//  Created by Ryan Bitner on 4/5/21.
//

import UIKit
protocol AddContactCellDelegate {
    func newContact(_ sender: AddContactCell)
}

class AddContactCell: UITableViewCell, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var contactImageView: UIImageView!
    
    var delegate: AddContactCellDelegate?
    var contact: Contact?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        guard let name = nameTextField.text, let image = contactImageView.image, let imageData = image.jpegData(compressionQuality: 0.9) else {return}
        contact = Contact(name: name, number: "", email: "", isFriend: true, contactPhoto: imageData)
        nameTextField.text = ""
        delegate?.newContact(self)
    }
    
}
