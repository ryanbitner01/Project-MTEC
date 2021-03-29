//
//  contactTableViewCell.swift
//  contacts
//
//  Created by Ryan Bitner on 3/29/21.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    //MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell() {
        
    }

}
