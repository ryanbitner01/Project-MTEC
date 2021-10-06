//
//  UserControllerAuth.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/12/21.
//

import Foundation
import Firebase
import UIKit

enum UserControllerError: Error {
    case passwordLength
    case passwordMatch
    case invalidUser
    case duplicateEmail
    case invalidEmail
    case noDisplayName
    case otherErr
    case noProfilePic
    case invalidDisplayName
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
        case .noProfilePic:
            return "No Picture Found for this profile."
        case .invalidDisplayName:
            return "This display name is invalid"
        }
        
    }
}

class UserControllerAuth {
    
    var user: User?
    var profile: Profile?
    static let shared = UserControllerAuth()
    
    func createUser(email: String, password: String, displayName: String, completion: @escaping (UserControllerError?) -> Void) {
        auth.createUser(withEmail: email, password: password) {authResult, error in
            if error != nil {
                completion(.duplicateEmail)
            } else {
                self.addDisplayName(email: email, displayName: displayName)
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
                        guard let displayName = displayName else {return}
                        let newUser = User(id: userID, displayName: displayName)
                        self.user = newUser
                        SocialController.shared.getProfile(self: true, email: email, completion: nil)
                        print("SIGNED IN")
                        completion(nil)
                    case .failure(let err):
                        displayName = "Default Name"
                        guard let displayName = displayName else {return}
                        let newUser = User(id: userID, displayName: displayName)
                        self.user = newUser
                        SocialController.shared.getProfile(self: true, email: email, completion: nil)
                        MigrationController.shared.changeName(new: displayName) { err in
                            if let err = err {
                                print(err.localizedDescription)
                            }
                        }
                        print("SIGNED IN")
                        completion(nil)
                        print(err.localizedDescription)
                    }
                }

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
    
    func addProfilePicture(user: User) {
        guard let imageData = user.image else {return}
        let storageRef = storage.reference()
        let imageRef = storageRef.child(user.displayName)
        guard let userPath = getUserPath() else {return}
        imageRef.putData(imageData, metadata: nil) {metaData, error in
            imageRef.downloadURL { url, err in
                if let err = err {
                    print(err.localizedDescription)
                } else if let url = url{
                    userPath.document(user.id).updateData([
                        "ProfilePic": url.absoluteString
                    ])
                }
            }
        }
    }
    
    func getProfilePic(profile: Profile?, completion: @escaping (Result<Data, UserControllerError>) -> Void) {
        if let profile = profile {
            let url = URL(string: profile.imageURL)
            guard let url = url, let imageData = try? Data(contentsOf: url) else {return completion(.failure(.noProfilePic))}
            completion(.success(imageData))
        } else {
            completion(.failure(.otherErr))
        }
    }
    
    func addDisplayName(email: String, displayName: String) {
        let path = getUserPath()
        path?.document(email).setData([
            "DisplayName": displayName
        ])
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
    
    func getAllDisplayNames(completion: @escaping (Result<[String], UserControllerError>)-> Void) {
        let userPath = getUserPath()
        userPath?.addSnapshotListener { docs, err in
            if let docs = docs {
                let displayNames = docs.documents.compactMap { doc -> String? in
                    let data = doc.data()
                    guard let name = data["DisplayName"] as? String else {return nil}
                    return name
                }
                completion(.success(displayNames))
            } else if let err = err {
                print(err)
                completion(.failure(.noDisplayName))
            } else {
                completion(.failure(.otherErr))
            }
        }
    }
    
}
