//
//  PersonTableViewCell.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/29/21.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var personImage: UIImageView!
    
    var user: String?
    var displayName: String?
    var profile: Profile?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getEmail() {
        guard let displayName = displayName else {return}
        SocialController.shared.getEmailFromDisplayName(displayName: displayName) { result in
            switch result {
            case .success(let email):
                self.getProfile(email: email)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func getProfile(email: String) {
        SocialController.shared.getProfile(self: false, email: email) { profile in
            self.profile = profile
            DispatchQueue.main.async {
                self.updateCell()
            }
        }
    }
    
    func setupImage() {
        UserControllerAuth.shared.getProfilePic(profile: self.profile) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.profile?.image = image
                    self.personImage.image = self.profile?.image
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func updateCell() {
        nameLabel.text = displayName
        setupImage()
    }

}
