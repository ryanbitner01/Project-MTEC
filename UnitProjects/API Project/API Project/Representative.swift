//
//  Representative.swift
//  API Project
//
//  Created by Ryan Bitner on 4/22/21.
//

import Foundation

struct RepSearchResponse: Codable {
    var results: [Representative]
}

struct Representative: Codable {
    var name: String
    var state: String
    var office: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case state = "state"
        case office = "office"
    }
}
