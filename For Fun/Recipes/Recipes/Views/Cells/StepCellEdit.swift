//
//  StepCellEdit.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/3/21.
//

import UIKit

protocol StepCellEditDelegate {
    func editStep(sender: Any)
}

class StepCellEdit: UITableViewCell {

    @IBOutlet weak var stepImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var step: Step?
    var delegate: StepCellEditDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell() {
        stepImageView.image = UIImage(systemName: "\(step?.order ?? 0).circle")
        descriptionLabel.text = step?.description
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        delegate?.editStep(sender: self)
    }
}
