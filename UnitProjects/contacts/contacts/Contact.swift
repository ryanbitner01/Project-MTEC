//
//  Contact.swift
//  contacts
//
//  Created by Ryan Bitner on 3/29/21.
//

import Foundation

struct Contact: Codable, Equatable {
    var name: String
    var number: String
    var email: String?
    var isFriend: Bool
    
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.name == rhs.name
    }
}
