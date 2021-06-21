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
//protocol BookControllerDelegate {
//    func booksUpdated()
//}

class BookController {

    //var delegate: BookControllerDelegate?
    
    static let colors: [String] = ["Lavender", "Green", "Red", "Blue", "Orange", "Pink"]

    let usersDirectory = db.collection("Users")
    static let shared = BookController()
    
    
    
    func updateSharedUsers(users: [String], book: Book) {
        guard let path = getPath(path: .album, email: nil) else {return}
        path.document(book.id.uuidString).updateData([
            "SharedUsers": users
        ])
    }
    
    func isOwner(book: Book) -> Bool {
        guard let user = UserControllerAuth.shared.user else {return false}
        return book.owner == user.id
    }
    
    func getPath(path: FireBasePath, email: String?) -> CollectionReference? {
        switch path {
        case .album:
            if let user = UserControllerAuth.shared.user {
                return usersDirectory.document(user.id).collection("Album")
            } else {
                return nil
            }
        case .otherSharedAlbum:
            if let email = email {
                return usersDirectory.document(email).collection("SharedAlbum")
            } else {
                return nil
            }
        case .sharedAlbum:
            if let user = UserControllerAuth.shared.user {
                return usersDirectory.document(user.id).collection("SharedAlbum")
            } else {
                return nil
            }
        }
    }

    func getBooks(user: User, path: FireBasePath, email: String = "", completion: @escaping (Result<[Book], Error>) -> Void) {
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

    func addBookImage(_ user: User, book: Book, new: Bool, path: FireBasePath, email: String = "") {
        guard let imageData = book.image else {return}
        let storageRef = storage.reference()
        let imageRef = storageRef.child(book.id.uuidString)
        imageRef.putData(imageData, metadata: nil) {metaData, error in
            imageRef.downloadURL { url, err in
                if let err = err {
                    print(err.localizedDescription)
                } else if let url = url{
                    if new {
                        self.addBook(user, book: book, imageUrl: url.absoluteString, path: path, email: email)
                    } else {
                        self.updateBook(book: book, imageURL: url.absoluteString, path: path, email: email)
                    }
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

    func deleteBook(book: Book, path: FireBasePath, email: String = "", completion: @escaping (BookError?) -> Void) {
        guard let path = getPath(path: path, email: email) else {return}
        if book.imageURL != " " {
            deleteBookImage(book: book)
        }
        path.document(book.id.uuidString).delete { err in
            if err != nil {
                completion(.failedToDelete)
            }
        }
    }

    func updateBook(book: Book, imageURL: String = " ", path: FireBasePath, email: String = "") {
        guard let path = getPath(path: path, email: email) else {return}
        path.document(book.id.uuidString).updateData([
            "name": book.name,
            "imageUrl": imageURL,
            "color": book.bookColor
        ])
        //delegate?.booksUpdated()
        //print("Updated Book")
    }

    func addBook(_ user: User, book: Book, imageUrl: String = "",path: FireBasePath, email: String = "") {
        guard let path = getPath(path: path, email: email) else {return}
        path.document(book.id.uuidString).setData([
            "name": book.name,
            "imageUrl": imageUrl,
            "color": book.bookColor,
            "Owner": book.owner,
            "SharedUsers": book.sharedUsers
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
    
    func getAlbum() -> [Book] {
        if let user = UserControllerAuth.shared.user {
            return user.album
        } else {
            return []
        }
    }
}
