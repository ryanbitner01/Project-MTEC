//
//  Profile.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/30/21.
//

import Foundation
import UIKit

class Profile {
    let name: String
    var email: String
    var imageURL: String
    var image: UIImage?
    
    init(name: String, email: String = "", imageURL: String = "",image: UIImage? = nil) {
        self.name = name
        self.email = email
        self.image = image
        self.imageURL = imageURL
    }
    
    func getProfile() {
        getEmail()
        getProfilePic()
    }
    
    func getEmail() {
        SocialController.shared.getEmailFromDisplayName(displayName: name) { result in
            switch result {
            case .success(let email):
                self.email = email
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func getProfilePic() {
        UserControllerAuth.shared.getProfilePic(profile: self) { result in
            switch result {
            case .success(let imageData):
                let image = imageData
                self.image = image
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
