//
//  Quote.swift
//  TestingArchitecture
//
//  Created by Ryan Bitner on 9/16/21.
//

import Foundation

struct Quote: Codable {
    let id: String
    let value: String
    let createdAt: String
    let tags: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "quote_id"
        case value, tags
        case createdAt = "created_at"
    }
}
