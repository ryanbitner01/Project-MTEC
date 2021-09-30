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
    
    //MARK: Sharing Controls
    
    func declineRequest(shareRequest: BookShareRequest) {
        guard let user = UserControllerAuth.shared.user, let selfPath = getPath(path: .sharedAlbum, email: user.id), let ownerProfile = shareRequest.ownerProfile, let otherPath = getPath(path: .otherSharedAlbum, email: ownerProfile.id) else {return}
        
        let sentRequest = SentBookShareRequest(bookName: shareRequest.bookName, user: user.id)
        
        let jsonEncoder = JSONEncoder()
        
        guard let requestData = try? jsonEncoder.encode(shareRequest),
              let sentRequestData = try? jsonEncoder.encode(sentRequest) else {return}
        //remove from self
        selfPath.document("BookShareRequests").updateData([
            "Requests": FieldValue.arrayRemove([requestData])
        ])
        
        //remove from other user
        otherPath.document("SentBookShareRequests").updateData([
            "Requests": FieldValue.arrayRemove([sentRequestData])
        ])
    }
    
    func acceptRequest(shareRequest: BookShareRequest) {
        guard let user = UserControllerAuth.shared.user else {return}
        
        let sentRequest = SentBookShareRequest(bookName: shareRequest.bookName, user: user.id)
        
        let jsonEncoder = JSONEncoder()
        
        guard let requestData = try? jsonEncoder.encode(shareRequest),
              let sentRequestData = try? jsonEncoder.encode(sentRequest) else {return}
        
        // Remove Request from other user
        guard let path = getPath(path: .sharedAlbum, email: user.id) else {return}
        guard let ownerProfile = shareRequest.ownerProfile else {return}
        guard let otherPath = getPath(path: .otherSharedAlbum, email: ownerProfile.id) else {return}
        
        otherPath.document("SentBookShareRequests").updateData([
            "Requests": FieldValue.arrayRemove([sentRequestData])
        ])
        // Remove Request from self
        path.document("BookShareRequests").updateData([
            "Requests": FieldValue.arrayRemove([requestData])
        ])
        
        // Add Book
        let book = BookCover(name: shareRequest.bookName, id: shareRequest.book, imageURL: shareRequest.bookImageURL, bookColor: shareRequest.bookColor, owner: shareRequest.ownerProfile?.id ?? "")
        addSharedBook(book: book)
        
        // Update Shared Users
        BookController.shared.addSharedUser(user: user.id, bookID: shareRequest.book, bookOwner: ownerProfile .id)
    }
    
    func addSharedBook(book: BookCover) {
        guard let user = UserControllerAuth.shared.user, let path = getPath(path: .sharedAlbum, email: user.id) else {return}
        path.document(book.id.uuidString).setData([
            "bookOwner": book.owner,
            "bookColor": book.bookColor,
            "bookName": book.name,
            "bookImageURL": book.imageURL ?? ""
        ])
        
    }
    
    func getSharedBookCovers(completion: @escaping (Result<[BookCover], SharingError>) -> Void) {
        guard let user = UserControllerAuth.shared.user, let path = getPath(path: .sharedAlbum, email: user.id) else {
            return completion(.failure(.noUser))
        }
        path.addSnapshotListener { qs, err in
            if let qs = qs {
                let bookCovers = qs.documents.compactMap { qds -> BookCover? in
                    let data = qds.data()
                    guard let name = data["bookName"] as? String, let color = data["bookColor"] as? String, let owner = data["bookOwner"] as? String, let imageURL = data["bookImageURL"] as? String, let uuid = UUID(uuidString: qds.documentID) else {return nil}
                    return BookCover(name: name, id: uuid, imageURL: imageURL, bookColor: color, owner: owner)
                }
                completion(.success(bookCovers))
            } else if let err = err {
                completion(.failure(.noUser))
                print(err.localizedDescription)
            }
        }
    }
    
    func revokeBookShare(profile: Profile, book: Book) {
        // Update shared with
        BookController.shared.removeSharedUser(user: profile.email, book: book)
                
        // Update Shared Album
        guard let path = getPath(path: .otherSharedAlbum, email: profile.email) else {return}
        path.document(book.id.uuidString).delete()
    }
    
    func revokeShareRequest(profile: Profile, request: SentBookShareRequest, book: Book) {
        
        guard let selfUser = UserControllerAuth.shared.user else {return}
        
        let ownerProfile = ProfileResult(name: profile.name, image: selfUser.imageURL, id: selfUser.id)
        
        let request = BookShareRequest(ownerProfile: ownerProfile, book: book.id, bookName: book.name, bookColor: book.bookColor, bookImageURL: book.imageURL ?? "")
        
        let sentRequest = SentBookShareRequest(bookName: book.name, user: profile.email)
        
        let jsonEncoder = JSONEncoder()
        
        guard let requestData = try? jsonEncoder.encode(request),
              let sentRequestData = try? jsonEncoder.encode(sentRequest) else {return}
        
        //Remove sent request
        
        guard let path = getPath(path: .sharedAlbum, email: selfUser.id) else {return}
        path.document("SentBookShareRequests").updateData([
            "Requests": FieldValue.arrayRemove([sentRequestData])
        ])
        
        //Remove request
        
        
        guard let otherPath = getPath(path: .otherSharedAlbum, email: profile.email) else {return}
        otherPath.document("BookShareRequests").updateData([
            "Requests": FieldValue.arrayRemove([requestData])
        ])
    }
    
    func getSentShareRequests(completion: @escaping ([SentBookShareRequest]?) -> Void) {
        guard let user = UserControllerAuth.shared.user, let path = getPath(path: .sharedAlbum, email: user.id) else {return completion(nil)}
                path.document("SentBookShareRequests").addSnapshotListener { doc, err in
                    if let doc = doc {
                        guard let docData = doc.data(),
                              let requests = docData["Requests"] as? [Any] else {return}
                        let shareRequests = requests.compactMap { request -> SentBookShareRequest? in
                            let jsonDecoder = JSONDecoder()
                            guard let data = request as? Data else {return nil}
                            do {
                                let result = try jsonDecoder.decode(SentBookShareRequest.self, from: data)
                                return result
                            } catch {
                                print(error.localizedDescription)
                                return nil
                            }
//                            if let data = try? JSONSerialization.data(withJSONObject: request, options: .prettyPrinted) {
//                                do {
//                                    let result = try jsonDecoder.decode(SentBookShareRequest.self, from: data)
//                                    return result
//                                } catch {
//                                    print(error)
//                                    return nil
//                                }
//                            } else {
//                                return nil
//                            }
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
        guard let user = UserControllerAuth.shared.user, let path = getPath(path: .sharedAlbum, email: user.id) else {return}
        path.document("BookShareRequests").addSnapshotListener { doc, err in
            if let doc = doc {
                guard let docData = doc.data(),
                      let requests = docData["Requests"] as? [Any] else {return}
                let shareRequests = requests.compactMap({ request -> BookShareRequest? in
                    let jsonDecoder = JSONDecoder()
                    guard let request = request as? Data else {return nil}
                    do {
                        let shareRequest = try jsonDecoder.decode(BookShareRequest.self, from: request)
                        return shareRequest
                        //print(data.prettyPrintedJSONString())
                    } catch {
                        print(error.localizedDescription)
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
    
    func sendShareRequest(book: Book, profile: Profile, completion: @escaping (SharingError?) -> Void) {
        
        guard let selfUser = UserControllerAuth.shared.user else {return}
        
        let ownerProfile = ProfileResult(name: profile.name, image: selfUser.imageURL, id: selfUser.id)
        
        let request = BookShareRequest(ownerProfile: ownerProfile, book: book.id, bookName: book.name, bookColor: book.bookColor, bookImageURL: book.imageURL ?? "")
        
        let sentRequest = SentBookShareRequest(bookName: book.name, user: profile.email)
        
        let jsonEncoder = JSONEncoder()
        
        guard let requestData = try? jsonEncoder.encode(request),
              let sentRequestData = try? jsonEncoder.encode(sentRequest) else {return}
        
        //        let owner: [String: Any] = [
        //            "Name": selfUser.id,
        //            "imageURL": selfUser.imageURL
        //        ]
        //
        //        let request: [String: Any] = [
        //            "book": book.id,
        //            "bookName": book.name,
        //            "bookColor": book.bookColor,
        //            "bookImageURL": book.imageURL,
        //            "bookOwner": owner
        //        ]
        //
        //        let sentRequest: [String: Any] = [
        //            "BookName": book.name,
        //            "User": profile.email
        //        ]
        
        guard let path = getPath(path: .otherSharedAlbum, email: profile.email) else {return}
        // Send Request to other user
        path.document("BookShareRequests").setData([
            "Requests": FieldValue.arrayUnion([requestData])
        ], mergeFields: [
            "Requests"
        ])
        
        
        
        // Update Sent Requests
        guard let selfPath = getPath(path: .sharedAlbum, email: selfUser.id) else {return}
        selfPath.document("SentBookShareRequests").setData([
            "Requests": FieldValue.arrayUnion([sentRequestData])
        ], mergeFields: [
            "Requests"
        ])
        
    }
    
    func canShare(book: Book, email: String, completion: @escaping (SharingError?) -> Void) {
        if checkDuplicateUser(book: book, email: email) {
            completion(.duplicateUser)
            //        } else if checkForSameEmail(book: book, email: email) {
            //            completion(.selfUser)
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
    //
    //    func checkForSameEmail(book: Book, email: String) -> Bool{
    //        if book.owner == email {
    //            return true
    //        } else {
    //            return false
    //        }
    //    }
    
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
