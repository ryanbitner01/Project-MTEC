//
//  Journal.swift
//  journal-test
//
//  Created by Ryan Bitner on 4/28/21.
//

import Foundation

struct Journal: Codable, Equatable {
    var entry: String
    var date: String
    
    static func == (lhs: Journal, rhs: Journal) -> Bool {
        return lhs.date == rhs.date
    }
}
