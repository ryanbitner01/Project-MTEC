//
//  Contact.swift
//  contacts
//
//  Created by Ryan Bitner on 3/29/21.
//

import Foundation

struct Contact: Codable {
    var name: String
    var number: String
    var email: String?
    var isFriend: Bool
    
}
