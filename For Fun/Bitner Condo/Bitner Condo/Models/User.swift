//
//  User.swift
//  Bitner Condo
//
//  Created by Ryan Bitner on 4/14/21.
//

import Foundation

struct User: Codable, Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.familyName == rhs.familyName
    }
    
    let isAdmin: Bool
    var username: String
    var password: String
    var familyName: String
    var reservations = [Reservation]()
    
    static var users: [User] = [
        User(isAdmin: true, username: "Admin", password: "1234", familyName: "Admin"),
        User(isAdmin: false, username: "User", password: "1234", familyName: "Test Family")
    ]
    
    init(isAdmin: Bool, username: String, password: String, familyName: String) {
        self.isAdmin = isAdmin
        self.username = username
        self.password = password
        self.familyName = familyName
    }
    
    static func checkPassword(username: String, password: String) -> Bool {
        var isCorrect = false
        for user in users {
            if user.username.lowercased() == username.lowercased() && user.password == password {
                isCorrect = true
            }
        }
        return isCorrect
    }
    
    static func loginUser(username: String) -> User? {
        var currentUser: User?
        for user in users {
            if user.username.lowercased() == username.lowercased() {
                currentUser = user
            }
        }
        return currentUser
    }
}

