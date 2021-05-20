//
//  User.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/5/21.
//

import Foundation

struct User: Codable {
    var id: String
    var album: [Book]
    
    
    init(id: String = "", album: [Book] = []) {
        self.id = id
        self.album = album
    }
    
}
