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
    var displayName: String?
    
    func updateCell() {
        getEmail()
        nameLabel.text = displayName
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
        UserControllerAuth.shared.getProfilePic(profile: profile) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.personImageView.image = data
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
}
