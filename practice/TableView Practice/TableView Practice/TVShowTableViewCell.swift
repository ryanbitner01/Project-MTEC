//
//  TVShowTableViewCell.swift
//  TableView Practice
//
//  Created by Ryan Bitner on 3/11/21.
//

import UIKit

class TVShowTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TVShowTableViewCell"

    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func update(with tvShow: TVShow) {
        timeAgoLabel.text = tvShow.watchedAtString
        titleLabel.text = tvShow.title
        descriptionLabel.text = tvShow.description
    }

}
