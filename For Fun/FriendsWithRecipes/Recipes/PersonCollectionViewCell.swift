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
    
    var email: String?
    var profile: Profile?
    
    func updateCell() {
        nameLabel.text = profile?.name
        setupImage()
    }
    
    func getProfile() {
        guard let email = email else {return}
        SocialController.shared.getProfile(self: false, email: email) { profile in
            DispatchQueue.main.async {
                DispatchQueue.main.async {
                    self.profile = profile
                    self.updateCell()
                }
            }
        }
    }
    
    func setupImage() {
        guard let profile = profile else {return}
        UserControllerAuth.shared.getProfilePic(profile: profile) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.profile?.image = data
                    if let data = profile.image {
                        self.personImageView.image = UIImage(data: data)
                    }
                }
            case .failure(let err):
                DispatchQueue.main.async {
                    self.personImageView.image = UIImage(systemName: "person.circle.fill")
                }
                print(err)
            }
        }
    }
    
}
