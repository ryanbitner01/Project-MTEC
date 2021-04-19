//
//  ResponseModels.swift
//  OrderApp
//
//  Created by Ryan Bitner on 4/19/21.
//

import Foundation

struct MenuResponse: Codable {
    let items: [MenuItem]
}

struct CategoryResponse: Codable {
    let categories: [String]
}

struct OrderResponse: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey {
        case prepTime = "preperation_time"
    }
}
