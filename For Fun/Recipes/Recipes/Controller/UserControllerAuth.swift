//
//  UserControllerAuth.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/12/21.
//

import Foundation

enum UserControllerError: Error {
    case passwordLength
    case passwordMatch
    case invalidUser
}

extension UserControllerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .passwordLength:
            return "Password must be at least 8 characters"
        case .passwordMatch:
            return "Password fields do not match."
        case .invalidUser:
            return "Invalid email or password"
        }
    }
}

class UserControllerAuth {
    
    var user: User?
    static let shared = UserControllerAuth()
    
    func createUser(email: String, password: String) {
        auth.createUser(withEmail: email, password: password)
    }
    
    func loginUser(email: String, password: String, completion: @escaping (UserControllerError?) -> Void) {
        auth.signIn(withEmail: email, password: password) { AuthData, err in
            if let data = AuthData {
                let userID = data.user.uid
                self.user = User(id: userID)
                print("SIGNED IN")
                completion(nil)
            } else {
                completion(.invalidUser)
            }
        }
    }
    
    func checkPasswordLength(password: String) -> Bool {
        return password.count >= 8
    }
    
    func checkSamePassword(p1: String, p2: String) -> Bool {
        return p1 == p2
    }
    
}
