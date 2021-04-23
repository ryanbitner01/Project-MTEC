//
//  ResponseModel.swift
//  API Project
//
//  Created by Ryan Bitner on 4/22/21.
//

import Foundation

struct DogURLResponse: Codable{
    var imageURL: URL
    
    enum CodingKeys: String, CodingKey{
        case imageURL = "message"
    }
}
