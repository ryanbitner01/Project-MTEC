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
        SocialController.shared.getProfileFromEmail(email: email) { result in
            switch result {
            case .success(let profile):
                self.setupImage(profile: profile)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func setupImage(profile: Profile) {
        personImage.makeRound()
        UserControllerAuth.shared.getProfilePic(profile: profile) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.personImage.image = data
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func updateCell() {
        nameLabel.text = displayName
        getEmail()
    }

}
