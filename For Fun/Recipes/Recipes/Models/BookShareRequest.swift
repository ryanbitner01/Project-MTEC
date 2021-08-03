//
//  BookShareRequest.swift
//  Recipes
//
//  Created by Ryan Bitner on 7/15/21.
//

import Foundation
import Firebase

struct BookShareRequest: Codable {
    let ownerProfile: ProfileResult?
    let book: UUID
    let bookName: String
    let bookColor: String
    let bookImageURL: String
    
    
    init(ownerProfile: ProfileResult? = nil, book: UUID, bookName: String, bookColor: String, bookImageURL: String) {
        self.book = book
        self.ownerProfile = ownerProfile
        self.bookName = bookName
        self.bookColor = bookColor
        self.bookImageURL = bookImageURL
    }
}
