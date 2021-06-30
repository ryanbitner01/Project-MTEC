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
    var user: Profile?
    
    func updateCell() {
        setupImage()
        nameLabel.text = user?.name
    }
    
    func setupImage() {
        personImageView.makeRound()
        if let image = user?.image {
            personImageView.image = image
        }
    }
    
}
