//
//  BookShareRequest.swift
//  Recipes
//
//  Created by Ryan Bitner on 7/15/21.
//

import Foundation

struct BookShareRequest {
    let name: String
    let owner: String
    let ownerProfile: Profile?
    let imageURL: String
    
    init(name: String, owner: String, ownerProfile: Profile? = nil, imageURL: String) {
        self.name = name
        self.owner = owner
        self.ownerProfile = ownerProfile
        self.imageURL = imageURL
    }
}
