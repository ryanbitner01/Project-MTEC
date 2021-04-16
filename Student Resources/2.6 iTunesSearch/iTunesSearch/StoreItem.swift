//
//  StoreItem.swift
//  iTunesSearch
//
//  Created by Ryan Bitner on 4/16/21.
//

import Foundation

struct SearchResponse: Codable {
    let results: [StoreItem]
}

struct StoreItem: Codable {
    var trackName: String
    var artistName: String
    var kind: String
    var description: String
    var artworkURL: URL?
    
    enum CodingKeys: String, CodingKey{
        case trackName
        case artistName
        case kind
        case description = "description"
        case artworkURL = "artworkUrl100"
        enum AdditionalKeys: String, CodingKey {
            case longDescription = "longDescription"
        }
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        trackName = try values.decode(String.self, forKey: CodingKeys.trackName)
        artistName = try values.decode(String.self, forKey: CodingKeys.artistName)
        kind = try values.decode(String.self, forKey: CodingKeys.kind)
        artworkURL = try? values.decode(URL.self, forKey: CodingKeys.artworkURL)
        
        if let description = try? values.decode(String.self, forKey: CodingKeys.description) {
            self.description = description
        } else {
            let additionalValues = try decoder.container(keyedBy: CodingKeys.AdditionalKeys.self)
            description = (try? additionalValues.decode(String.self, forKey: CodingKeys.AdditionalKeys.longDescription)) ?? ""
        }
    }
}
