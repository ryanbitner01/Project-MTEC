//
//  ToDoCellTableViewCell.swift
//  ToDoList
//
//  Created by Ryan Bitner on 3/30/21.
//

import UIKit

protocol ToDoCellDegegate: AnyObject {
    func checkmarkTapped(sender: ToDoCellTableViewCell)
}

class ToDoCellTableViewCell: UITableViewCell {
    
    weak var delegate: ToDoCellDegegate?

    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        delegate?.checkmarkTapped(sender: self)
    }
    

}
