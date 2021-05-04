//
//  File.swift
//  journal-test
//
//  Created by Ryan Bitner on 4/28/21.
//

import Foundation

struct User: Codable {
    var ID = UUID()
    var journal = [Journal]()
    var user: String
    var password: String
    var email: String
    
    static var users: [User] = []
    
    static func checkPasswordLength(_ password: String) -> Bool {
        return password.count >= 7
    }
    
    static func checkPasswordMatch(p1: String, p2: String) -> Bool {
        return p1 == p2
    }
    
    static func checkUserDuplicate(_ username: String) -> Bool {
        var tf = true
        for user in users {
            if user.user == username {
                tf = false
                break
            }
        }
        return tf
    }
    
    static func checkValidUser(username: String, password: String) -> User? {
        var userCheck: User?
        var passwordCheck = false
        for user in users {
            if user.user.lowercased() == username.lowercased() {
                userCheck = user
            }
            if user.password == password {
                passwordCheck = true
            }
        }
        guard userCheck != nil, passwordCheck == true else {return nil}
        return userCheck
    }
}
