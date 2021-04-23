//
//  NobelPrize.swift
//  API Project
//
//  Created by Ryan Bitner on 4/23/21.
//

import Foundation

struct NobelResponse: Codable {
    var prizes: [NobelPrize]
}

struct NobelPrize: Codable {
    let year: String
    let category: String
    let laureates: [Laureate]
    
    enum CodingKeys: String, CodingKey {
        case year = "year"
        case category = "category"
        case laureates = "laureates"
    }
}

struct Laureate: Codable {
    let firstname: String
    let surname: String
    var fullname: String {
        firstname + " " + surname
    }
    enum CodingKeys: String, CodingKey {
        case firstname
        case surname
    }
}
