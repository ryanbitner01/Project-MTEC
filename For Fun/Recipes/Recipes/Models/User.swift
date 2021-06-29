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
    
    init(id: String = "", album: [Book] = [], sharedAlbum: [Book] = [], displayName: String, image: Data? = nil) {
        self.id = id
        self.album = album
        self.sharedAlbum = sharedAlbum
        self.displayName = displayName
        self.image = image
    }
    
}
