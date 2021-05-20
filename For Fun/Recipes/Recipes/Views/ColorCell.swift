//
//  ColorCell.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/10/21.
//

import UIKit

class ColorCell: UICollectionViewCell {
    
    var color: UIColor?
    
    @IBOutlet weak var colorImage: UIImageView!
    
    func updateCell() {
        guard let color = color else {return}
        colorImage.tintColor = color
    }
    
}
