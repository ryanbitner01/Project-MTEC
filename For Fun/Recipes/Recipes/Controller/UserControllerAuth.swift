//
//  UserControllerAuth.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/12/21.
//

import Foundation
import Firebase

enum UserControllerError: Error {
    case passwordLength
    case passwordMatch
    case invalidUser
    case duplicateEmail
    case invalidEmail
    case noDisplayName
    case otherErr
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
        case .noDisplayName:
            return "No Display Name Found"
        case .otherErr:
            return "An Error Has Occured"
        }
        
    }
}

let testingEnabled = true

class UserControllerAuth {
    
    var user: User?
    static let shared = UserControllerAuth()
    
    func getUserPath() -> CollectionReference? {
        if testingEnabled {
            return db.collection("TestUsers")
        } else {
            return db.collection("Users")
        }
    }
    
    func getPath(path: FireBasePath, email: String?) -> CollectionReference? {
        guard let userPath = getUserPath() else {return nil}
        switch path {
        case .newAlbum:
            if let email = email {
                return userPath.document(email).collection("Album")
            } else {
                return nil
            }
        case .album:
            if let user = UserControllerAuth.shared.user {
                return userPath.document(user.id).collection("Album")
            } else {
                return nil
            }
        case .otherSharedAlbum:
            if let email = email {
                return userPath.document(email).collection("SharedAlbum")
            } else {
                return nil
            }
        case .sharedAlbum:
            if let user = UserControllerAuth.shared.user {
                return userPath.document(user.id).collection("SharedAlbum")
            } else {
                return nil
            }
        }
    }
    
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
                var displayName: String?
                self.getDisplayName(email: email) { result in
                    switch result {
                    case .success(let name):
                        displayName = name
                    case .failure(let err):
                        print(err)
                    }
                }
                guard let displayName = displayName else {return}
                self.user = User(id: userID, displayName: displayName)
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
    
    func rememberEmail(email: String, rememberMe: Bool) {
        UserDefaults.standard.setValue(email, forKey: "userEmail")
        UserDefaults.standard.setValue(rememberMe, forKey: "rememberMe")
    }
    
    func getRememberedEmail() -> String {
        guard let email = UserDefaults.standard.value(forKey: "userEmail") as? String else {return ""}
        return email
    }
    
    func getRememberMe() -> Bool {
        guard let rememberMe = UserDefaults.standard.value(forKey: "rememberMe") as? Bool else {return false}
        return rememberMe
    }
    
    func getDisplayName(email: String, completion: @escaping (Result<String, UserControllerError>) -> Void) {
        guard let path = getUserPath() else {return}
        path.document(email).getDocument { doc, err in
            if let doc = doc {
                guard let data = doc.data(), let displayName = data["DisplayName"] as? String else {return completion(.failure(.noDisplayName))}
                completion(.success(displayName))
            } else if let err = err {
                print(err)
                completion(.failure(.otherErr))
            } else {
                completion(.failure(.otherErr))
            }
        }
        
    }
    
}
