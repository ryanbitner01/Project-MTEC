//
//  ContactCell.swift
//  contacts
//
//  Created by Ryan Bitner on 3/30/21.
//

import UIKit

protocol ContactCellDelegate {
    func switchChanged(_ sender: ContactCell)
}

class ContactCell: UITableViewCell {
    
    @IBOutlet weak var contactPhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isFriendSwitch: UISwitch!
    
    var contact: Contact?
    var delegate: ContactCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell() {
        guard let contact = contact else {return}
        nameLabel.text = contact.name
        isFriendSwitch.isOn = contact.isFriend
        guard let image = contact.image else {return}
        contactPhoto.image = UIImage(data: image)
    }
    
    @IBAction func isFriendChanged(_ sender: UISwitch) {
        delegate?.switchChanged(self)
    }
    

}
