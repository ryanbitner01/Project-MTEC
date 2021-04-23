//
//  RepTableViewCell.swift
//  API Project
//
//  Created by Ryan Bitner on 4/22/21.
//

import UIKit

class RepTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var officeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(name: String, state: String, office: String) {
        nameLabel.text = name
        stateLabel.text = state
        officeLabel.text = office
    }

}
