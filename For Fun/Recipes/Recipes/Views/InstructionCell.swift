//
//  InstructionCell.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/17/21.
//

import UIKit

class InstructionCell: UITableViewCell {

    @IBOutlet weak var indexImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var instruction: Instruction?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell() {
        let systemImageString = "\(instruction?.order ?? 0).circle.fill"
        indexImageView.image = UIImage(systemName: systemImageString)
        descriptionLabel.text = instruction?.descrtiption
    }

}
