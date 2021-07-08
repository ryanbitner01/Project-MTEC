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
    var friends: [String]
    var requests: [String]
    var pendingFriends: [String]
    
    init(name: String, email: String = "", imageURL: String = "",image: UIImage? = nil, friends: [String] = [], requests: [String] = [], pendingFriends: [String] = []) {
        self.name = name
        self.email = email
        self.image = image
        self.imageURL = imageURL
        self.friends = friends
        self.requests = requests
        self.pendingFriends = pendingFriends
    }
    
    
}
