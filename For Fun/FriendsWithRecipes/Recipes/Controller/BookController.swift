//
//  BookController.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/10/21.
//

import Foundation
import Firebase
import UIKit

enum BookError: Error {
    case noImage
    case failedToDelete
}

extension BookError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noImage:
            return "Can't Find Image"
        case .failedToDelete:
            return "Couldn't delete File"
        }
    }
}

enum FireBasePath {
    case otherSharedAlbum
    case sharedAlbum
    case album
}

enum UserPath {
    case testUsers
    case users
}

func getPath(path: FireBasePath, email: String) -> CollectionReference? {
    guard let userPath = getUserPath() else {return nil}
    switch path {
    case .album:
        return userPath.document(email).collection("Album")
        
    case .otherSharedAlbum:
        return userPath.document(email).collection("SharedAlbum")
    case .sharedAlbum:
        return userPath.document(email).collection("SharedAlbum")
    }
}

func getUserPath() -> CollectionReference? {
    if testingEnabled {
        return db.collection("TestUsers")
    } else {
        return db.collection("Users")
    }
}

class BookController {
    
    //var delegate: BookControllerDelegate?
    
    static let colors: [String] = ["Lavender", "Green", "Red", "Blue", "Orange", "Pink"]
    
    let usersDirectory = db.collection("Users")
    static let shared = BookController()
    
    
    
    func updateSharedUsers(users: [String], book: Book) {
        guard let path = getPath(path: .album, email: book.owner) else {return}
        path.document(book.id.uuidString).updateData([
            "SharedUsers": users
        ])
    }
    
    func addSharedUser(user: String, bookID: UUID, bookOwner: String) {
        guard let path = getPath(path: .album, email: bookOwner) else {return}
        path.document(bookID.uuidString).setData([
            "SharedUsers": FieldValue.arrayUnion([user])
        ], mergeFields: [
            "SharedUsers"
        ])
    }
    
    func removeSharedUser(user: String, book: Book) {
        guard let path = getPath(path: .album, email: book.owner) else {return}
        path.document(book.id.uuidString).updateData([
            "SharedUsers": FieldValue.arrayRemove([user])
        ])
    }
    
    func isOwner(book: BookCover) -> Bool {
        guard let user = UserControllerAuth.shared.user else {return false}
        return book.owner == user.id
    }
    
    func getBookCovers(completion: @escaping (Result<[BookCover], Error>) -> Void) {
        guard let user = UserControllerAuth.shared.user, let path = getPath(path: .album, email: user.id) else {return}
        path.addSnapshotListener { querySnapshot, error in
            if let querySS = querySnapshot {
                let books = querySS.documents.compactMap { doc -> BookCover? in
                    let data = doc.data()
                    guard let name = data["name"] as? String, let url = data["imageUrl"] as? String, let bookColor = data["color"] as? String, let owner = data["Owner"] as? String ,let uuidString = UUID(uuidString: doc.documentID) else {return nil}
                    let book = BookCover(name: name, id: uuidString, imageURL: url, bookColor: bookColor, owner: owner)
                    return book
                }
                completion(.success(books))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func getBook(bookCover: BookCover, path: FireBasePath, email: String, completion: @escaping (Result<Book, Error>) -> Void) {
        guard let path = getPath(path: path, email: email) else {return}
        path.document(bookCover.id.uuidString).addSnapshotListener { qs, err in
            if let qs = qs {
                guard let data = qs.data(),
                      let name = data["name"] as? String,
                      let url = data["imageUrl"] as? String,
                      let bookColor = data["color"] as? String,
                      let sharedUsers = data["SharedUsers"] as? [String],
                      let owner = data["Owner"] as? String,
                      let uuidString = UUID(uuidString: qs.documentID) else {return}
                let book = Book(name: name, id: uuidString, imageURL: url, bookColor: bookColor, sharedUsers: sharedUsers, owner: owner)
                completion(.success(book))
            }
        }
    }
    
    func getBooks(path: FireBasePath, email: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        guard let path = getPath(path: path, email: email) else {return}
        path.getDocuments { querySnapshot, error in
            if let querySS = querySnapshot {
                let books = querySS.documents.compactMap { doc -> Book? in
                    let data = doc.data()
                    guard let name = data["name"] as? String, let url = data["imageUrl"] as? String, let bookColor = data["color"] as? String, let sharedUsers = data["SharedUsers"] as? [String], let owner = data["Owner"] as? String ,let uuidString = UUID(uuidString: doc.documentID) else {return nil}
                    let book = Book(name: name, id: uuidString, imageURL: url, bookColor: bookColor, sharedUsers: sharedUsers, owner: owner)
                    return book
                }
                completion(.success(books))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func getBookImage(url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let url = URL(string: url)
        guard let url = url, let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) else {
            completion(.failure(BookError.noImage))
            return
        }
        completion(.success(image))
    }
    
    func addBookImage(image: Data, book: BookCover, new: Bool, path: FireBasePath, email: String) {
        let storageRef = storage.reference()
        let imageRef = storageRef.child(book.id.uuidString)
        imageRef.putData(image, metadata: nil) {metaData, error in
            imageRef.downloadURL { url, err in
                if let err = err {
                    print(err.localizedDescription)
                } else if let url = url{
                    self.addBook(book: book, imageUrl: url.absoluteString, path: path, email: email)
                }
            }
        }
        
        
    }
    
    func deleteBookImage(book: Book) {
        let storageRef = storage.reference()
        let imageRef = storageRef.child(book.id.uuidString)
        imageRef.delete { err in
            if let err = err {
                print(err.localizedDescription)
            } else {
                print("Image Deleted")
            }
        }
    }
    
    func deleteBook(book: Book, path: FireBasePath, email: String, completion: @escaping (BookError?) -> Void) {
        guard let path = getPath(path: path, email: email) else {return}
        if book.imageURL != " " {
            deleteBookImage(book: book)
        }
        for user in book.sharedUsers {
            self.deleteBook(book: book, path: .otherSharedAlbum, email: user) { err in
                if let err = err {
                    print(err.localizedDescription)
                }
            }
        }
        path.document(book.id.uuidString).delete { err in
            if err != nil {
                completion(.failedToDelete)
            }
        }
    }
    
    func addBook(book: BookCover, imageUrl: String,path: FireBasePath, email: String) {
        guard let path = getPath(path: path, email: email) else {return}
        path.document(book.id.uuidString).setData([
            "name": book.name,
            "imageUrl": imageUrl,
            "color": book.bookColor,
            "Owner": book.owner
        ])
        //delegate?.booksUpdated()
        //print("NEW BOOK!")
    }
    
    func getBookColor(book: Book) -> UIColor {
        switch book.bookColor {
        case "black":
            return UIColor.black
        case "pink":
            return UIColor.systemPink
        case "orange":
            return UIColor.systemOrange
        case "red":
            return UIColor.red
        case "blue":
            return UIColor.blue
        default:
            return UIColor.black
        }
    }
    
    func getAlbum() -> [BookCover] {
        if let user = UserControllerAuth.shared.user {
            return user.album
        } else {
            return []
        }
    }
}
