//
//  BookShareRequest.swift
//  Recipes
//
//  Created by Ryan Bitner on 7/15/21.
//

import Foundation

struct BookShareRequest: Codable {
    let ownerProfile: ProfileResult?
    let book: Book
    
    init(ownerProfile: ProfileResult? = nil, book: Book) {
        self.book = book
        self.ownerProfile = ownerProfile
        
    }
    
    enum CodingKeys: String, CodingKey {
        case book = "book"
        case ownerProfile = "bookOwner"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let data = try values.decode(Data.self, forKey: .book)
        book = try JSONDecoder().decode(Book.self, from: data)
        ownerProfile = try values.decode(ProfileResult.self, forKey: .ownerProfile)
    }
}
