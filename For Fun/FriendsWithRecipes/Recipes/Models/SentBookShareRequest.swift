//
//  SentBookShareRequest.swift
//  Recipes
//
//  Created by Ryan Bitner on 7/16/21.
//

import Foundation

struct SentBookShareRequest: Codable, Equatable {
    var bookName: String
    var user: String
    
    init(bookName: String, user: String) {
        self.bookName = bookName
        self.user = user
    }
    
    enum CodingKeys: String, CodingKey {
        case bookName = "BookName"
        case user = "User"
    }
}
