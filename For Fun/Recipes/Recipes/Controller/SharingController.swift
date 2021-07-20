//
//  SharingController.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/22/21.
//

import Foundation
import Firebase

enum SharingError: Error {
    case duplicateUser
    case selfUser
    case userDoesNotExist
    case noUser
}

extension SharingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .duplicateUser:
            return "Already shared with this user"
        case .selfUser:
            return "This user is your self"
        case .userDoesNotExist:
            return "This user is not found, check your spelling."
        case .noUser:
            return "No user selected."
        }
    }
}

class SharingController {
    
    
    
    static let shared = SharingController()
    
    private init() {
        
    }
    
    func revokeShareRequest(profile: Profile, request: SentBookShareRequest) {
        
        let sentRequest: [String: Any] = [
            "BookName": request.bookName,
            "User": request.user
        ]
        
        guard let path = getPath(path: .sharedAlbum, email: nil) else {return}
        path.document("SentBookShareRequests").updateData([
            "Requests": FieldValue.arrayRemove([sentRequest])
        ])
    }
    
    func getSentShareRequests(completion: @escaping ([SentBookShareRequest]?) -> Void) {
        guard let path = getPath(path: .sharedAlbum, email: nil) else {return completion(nil)}
        path.document("SentBookShareRequests").addSnapshotListener { doc, err in
            if let doc = doc {
                guard let docData = doc.data(),
                      let requests = docData["Requests"] as? [Any] else {return}
                let shareRequests = requests.compactMap { request -> SentBookShareRequest? in
                    let jsonDecoder = JSONDecoder()
                    if let data = try? JSONSerialization.data(withJSONObject: request, options: .prettyPrinted) {
                        do {
                            let result = try jsonDecoder.decode(SentBookShareRequest.self, from: data)
                            return result
                        } catch {
                            print(error)
                            return nil
                        }
                    } else {
                        return nil
                    }
                }
                completion(shareRequests)
            } else if let err = err {
                print(err.localizedDescription)
                completion(nil)
            } else {
                completion(nil)
            }
        }
    }
    
    func getShareRequests(completion: @escaping ([BookShareRequest]?) -> Void) {
        guard let path = getPath(path: .sharedAlbum, email: nil) else {return}
        path.document("BookShareRequests").addSnapshotListener { doc, err in
            if let doc = doc {
                guard let docData = doc.data(),
                      let requests = docData["Requests"] as? [Any] else {return}
                let shareRequests = requests.compactMap({ request -> BookShareRequest? in
                    let jsonDecoder = JSONDecoder()
                    if let data = try? JSONSerialization.data(withJSONObject: request, options: .prettyPrinted) {
                        print(data.prettyPrintedJSONString())
                        do {
                            let result = try jsonDecoder.decode(BookShareRequest.self, from: data)
                            print(data.prettyPrintedJSONString())
                            print(result)
                            return result
                        } catch {
                            print(error.localizedDescription)
                            return nil
                        }
                    } else {
                        return nil
                    }
                })
                completion(shareRequests)
            } else if let err = err {
                print(err.localizedDescription)
                completion(nil)
            } else {
                completion(nil)
            }
        }
    }
    
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
    
    func sendShareRequest(book: Book, profile: Profile, completion: @escaping (SharingError?) -> Void) {
        
        guard let selfUser = UserControllerAuth.shared.user else {return}
        
        let owner: [String: Any] = [
            "Name": selfUser.id,
            "imageURL": selfUser.imageURL
        ]
        
        let request: [String: Any] = [
            "bookName": book.name,
            "bookImage": book.imageURL ?? "",
            "bookColor": book.bookColor,
            "bookOwner": owner
        ]
        guard let path = getPath(path: .otherSharedAlbum, email: profile.email) else {return}
        // Send Request to other user
        path.document("BookShareRequests").setData([
            "Requests": FieldValue.arrayUnion([request])
        ], mergeFields: [
            "Requests"
        ])
                
        let sentRequest: [String: Any] = [
            "BookName": book.name,
            "User": profile.email
        ]
        
        // Update Sent Requests
        guard let selfPath = getPath(path: .sharedAlbum, email: nil) else {return}
        selfPath.document("SentBookShareRequests").setData([
            "Requests": FieldValue.arrayUnion([sentRequest])
        ], mergeFields: [
            "Requests"
        ])
        
    }
    
    func canShare(book: Book, email: String, completion: @escaping (SharingError?) -> Void) {
        if checkDuplicateUser(book: book, email: email) {
            completion(.duplicateUser)
        } else if checkForSameEmail(book: book, email: email) {
            completion(.selfUser)
        } else {
            userExists(email: email) { err in
                if let err = err {
                    completion(err)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func checkDuplicateUser(book: Book, email: String) -> Bool {
        if book.sharedUsers.contains(email) {
            return true
        } else {
            return false
        }
    }
    
    func checkForSameEmail(book: Book, email: String) -> Bool{
        if book.owner == email {
            return true
        } else {
            return false
        }
    }
    
    func userExists(email: String, completion: @escaping (SharingError?) -> Void) {
        let docRef = db.collection("Users").document(email)
        docRef.getDocument { doc, err in
            if let doc = doc, doc.exists {
                completion(nil)
            } else if let err = err{
                print(err.localizedDescription)
                completion(.userDoesNotExist)
            } else {
                completion(nil)
            }
        }
    }
}
