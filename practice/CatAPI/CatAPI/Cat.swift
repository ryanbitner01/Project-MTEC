//
//  Cat.swift
//  CatAPI
//
//  Created by Ryan Bitner on 5/7/21.
//

import Foundation

struct Cat: Codable {
    let id: Int
    let url: String
    let webpurl: String
    let x: Float
    let y: Float
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case webpurl
        case x
        case y
    }
}

struct ImageCache {
    
}
