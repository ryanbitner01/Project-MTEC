//
//  PersonCollectionViewCell.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/29/21.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var user: String?
    
    func updateCell() {
        setupImage()
        nameLabel.text = user
    }
    
    func setupImage() {
        personImageView.makeRound()
    }
    
}
