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
    case duplicateEmail
    case invalidEmail
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
        case .duplicateEmail:
            return "Email already in use"
        case .invalidEmail:
            return "Email does not exist"
        }
        
    }
}

class UserControllerAuth {
    
    var user: User?
    static let shared = UserControllerAuth()
    
    func createUser(email: String, password: String, completion: @escaping (UserControllerError?) -> Void) {
        auth.createUser(withEmail: email, password: password) {authResult, error in
            if error != nil {
                completion(.duplicateEmail)
            } else {
                completion(nil)
            }
        }
        
    }
    
    func loginUser(email: String, password: String, completion: @escaping (UserControllerError?) -> Void) {
        auth.signIn(withEmail: email, password: password) { AuthData, err in
            if let data = AuthData {
                guard let userID = data.user.email else {return}
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
    
    func logoutUser() {
        try? auth.signOut()
        user = nil
    }
    
    func sendPasswordReset(email: String, completion: @escaping (UserControllerError?) -> Void) {
        auth.sendPasswordReset(withEmail: email) { err in
            if err != nil {
                completion(.invalidEmail)
            }
        }
    }
    
}
