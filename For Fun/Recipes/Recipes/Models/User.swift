//
//  User.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/5/21.
//

import Foundation

class User: Codable {
    var id: String
    var album: [Book]
    var sharedAlbum: [Book]
    var displayName: String
    var image: Data?
    var imageURL: String
    var pendingFriends: [String]
    var friends: [String]
    
    init(id: String = "", album: [Book] = [], sharedAlbum: [Book] = [], displayName: String, image: Data? = nil, friends: [String] = [], pendingFriends: [String] = [], imageURL: String = "") {
        self.id = id
        self.album = album
        self.sharedAlbum = sharedAlbum
        self.displayName = displayName
        self.image = image
        self.friends = friends
        self.pendingFriends = pendingFriends
        self.imageURL = imageURL
    }
    
}
