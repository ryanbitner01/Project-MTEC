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
    
    init(id: String = "", album: [Book] = [], sharedAlbum: [Book] = []) {
        self.id = id
        self.album = album
        self.sharedAlbum = sharedAlbum
    }
    
}
