//
//  Profile.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/30/21.
//

import Foundation
import UIKit

class Profile: Codable {
    let name: String
    var email: String
    var imageURL: String
    var image: Data?
    var friends: [String]
    var requests: [String]
    var pendingFriends: [String]
    var noticationTokens: [String]
    
    init(name: String, email: String = "", imageURL: String = "",image: Data? = nil, friends: [String] = [], requests: [String] = [], pendingFriends: [String] = [], notificationTokens: [String] = []) {
        self.name = name
        self.email = email
        self.image = image
        self.imageURL = imageURL
        self.friends = friends
        self.requests = requests
        self.pendingFriends = pendingFriends
        self.noticationTokens = notificationTokens
    }
    
    
}

struct ProfileResult: Codable {
    let name: String
    let image: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case image = "imageURL"
        case id = "id"
    }
}
