//
//  CircleImageView.swift
//  Recipes
//
//  Created by Ryan Bitner on 7/7/21.
//

import UIKit

class CircleImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.makeRound()
    }
    
    func makeRound() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

