//
//  UserControllerTestAPI.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/6/21.
//

//import Foundation
//
//protocol UserControllerDelegate {
//    func updatedUser()
//}
//
//enum UserError: Error, CustomStringConvertible {
//    var description: String {
//        switch self {
//        case .usernameTaken:
//            return "User Already Exists"
//        case .passwordLength:
//            return "Password must be at least 8 characters"
//        case .passwordMatch:
//            return "Passwords do not match"
//        case .usernameLength:
//            return "Username must be at least 8 characters"
//        }
//    }
//
//    case usernameLength
//    case passwordLength
//    case passwordMatch
//    case usernameTaken
//
//
//}
//
//class UserController {
//
//    static let shared = UserController()
//    var users: [User] = [] {
//        didSet {
//            delegate?.updatedUser()
//        }
//    }
//
//    var delegate: UserControllerDelegate?
//
//    var user: User? {
//        didSet {
//            getUsers { result in
//                switch result {
//                case .success(let users):
//                    UserController.shared.users = users
//                case .failure(let err):
//                    print(err.localizedDescription)
//                }
//            }
//        }
//    }
//    var usersDirectory = db.collection("Users")
//
//    func getUsers(completion: @escaping (Result<[User], Error>) -> Void) {
//        usersDirectory.getDocuments { qs, err in
//            if let qs = qs {
//                let users = qs.documents.compactMap { doc -> User? in
//                    let data = doc.data()
//                    guard let password = data["password"] as? String, let email = data["email"] as? String else {return nil}
//                    return User(name: doc.documentID, password: password, email: email)
//                }
//                completion(.success(users))
//            } else if let err = err {
//                completion(.failure(err))
//            }
//        }
//    }
//
//    func getUser(username: String) -> User? {
//        return UserController.shared.users.first(where: {$0.name.lowercased() == username})
//    }
//
//
//
//    func addUser(user: User) {
//        usersDirectory.document(user.name).setData([
//            "password": user.password,
//            "email": user.email
//        ])
//    }
//
//    func checkDuplicateUser(username: String) -> Bool {
//        if UserController.shared.users.first(where: {$0.name.lowercased() == username.lowercased()}) == nil {
//            return false
//        } else {
//            return true
//        }
//    }
//
//    func checkPasswordLength(password: String) -> Bool {
//        return password.count >= 8
//    }
//
//    func checkSamePassword(p1: String, p2: String) -> Bool {
//        return p1 == p2
//    }
//
//    func checkUsernameLength(username: String) -> Bool {
//        return username.count >= 8
//    }
//
//    func loginUser(username: String, password: String) -> Bool {
//        guard let newUser = getUser(username: username.lowercased()), newUser.password == password else {return false}
//        UserController.shared.user = newUser
//        return true
//    }
//
//}
