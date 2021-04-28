//
//  File.swift
//  journal-test
//
//  Created by Ryan Bitner on 4/28/21.
//

import Foundation

struct User: Codable {
    var ID = UUID()
    var journal: [Journal]
    var user: String
    var password: String
}
