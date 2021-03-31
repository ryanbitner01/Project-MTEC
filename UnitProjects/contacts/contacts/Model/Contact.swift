//
//  Contact.swift
//  contacts
//
//  Created by Ryan Bitner on 3/29/21.
//

import UIKit

struct Contact: Codable, Equatable {
    var image: Data?
    var ID = UUID()
    var name: String
    var number: String
    var email: String?
    var isFriend: Bool
    
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.ID == rhs.ID
    }
    
    init(name: String, number: String, email: String, isFriend: Bool) {
        self.name = name
        self.number = number
        self.email = email
        self.isFriend = isFriend
    }
    init(name: String, number: String, email: String, isFriend: Bool, contactPhoto: Data?) {
        self.name = name
        self.number = number
        self.email = email
        self.isFriend = isFriend
        self.image = contactPhoto
    }
}
