//
//  BookShareRequest.swift
//  Recipes
//
//  Created by Ryan Bitner on 7/15/21.
//

import Foundation

struct BookShareRequest: Codable {
    let name: String
    let ownerProfile: ProfileResult?
    let imageURL: String
    let color: String
    
    init(name: String, ownerProfile: ProfileResult? = nil, imageURL: String, bookColor: String) {
        self.name = name
        self.ownerProfile = ownerProfile
        self.imageURL = imageURL
        self.color = bookColor
    }
    
    enum CodingKeys: String, CodingKey {
        case color = "bookColor"
        case imageURL = "bookImage"
        case name = "bookName"
        case ownerProfile = "bookOwner"
    }
}
