//
//  User.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/5/21.
//

import Foundation

struct User: Codable {
    var id: UUID
    var name: String
    var password: String
    var album: [Book]
    
    init(id: UUID = UUID(), name: String, password: String, album: [Book] = []) {
        self.id = id
        self.name = name
        self.password = password
        self.album = album
    }
    
}
