//
//  NobelTableViewCell.swift
//  API Project
//
//  Created by Ryan Bitner on 4/23/21.
//

import UIKit

class NobelTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(name: String, category: String, year: String) {
        nameLabel.text = name
        yearLabel.text = year
        categoryLabel.text = category
    }

}
