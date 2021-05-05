//
//  UserControllerTest.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/5/21.
//

import Foundation

enum UserError: Error, CustomStringConvertible {
    var description: String {
        switch self {
        case .duplicateUser:
            return "User already Exists"
        case .passwordLength:
            return "Password is too short, it must be 8 characters or more."
        case .passwordMatch:
            return "Passwords don't match"
        case .noUserFound:
            return "No user found"
        }
    }
    
    case duplicateUser
    case passwordLength
    case passwordMatch
    case noUserFound
}

class UserControllerTest {
    
    static let shared = UserControllerTest()
    
    static var user: User?
    static var users: [User] = [User(name: "test", password: "1234")]
    
    
    
    static func getUser(username: String) -> User? {
        return users.first(where: {$0.name == username})
    }
    
    static func addUser(user: User) {
        users.append(user)
    }
    
    static func checkRequirements(username: String, password: String, p2: String) -> Result<User, Error>{
        guard !checkDuplicateUser(username: username) else { return .failure(UserError.duplicateUser ) }
        guard checkSamePassword(p1: password, p2: p2) else { return .failure(UserError.passwordMatch) }
        guard checkPasswordLength(password: password) else { return .failure(UserError.passwordLength) }
        return .success(User(name: username, password: password))
    }
    
    static func checkDuplicateUser(username: String) -> Bool {
        if users.first(where: {$0.name.lowercased() == username.lowercased()}) == nil {
            return false
        } else {
            return true
        }
    }
    
    static func checkPasswordLength(password: String) -> Bool {
        return password.count >= 8
    }
    
    static func checkSamePassword(p1: String, p2: String) -> Bool {
        return p1 == p2
    }
    
    static func loginUser(username: String, password: String) {
        guard let user = getUser(username: username), user.password == password else {return}
        self.user = user
    }
    
}
