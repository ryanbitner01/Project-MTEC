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
}

//protocol BookControllerDelegate {
//    func booksUpdated()
//}

class BookController {

    //var delegate: BookControllerDelegate?

    let usersDirectory = db.collection("Users")
    static let shared = BookController()

    func getBooks(user: User, completion: @escaping (Result<[Book], Error>) -> Void) {
        usersDirectory.document(user.id).collection("Album").getDocuments { querySnapshot, error in
            if let querySS = querySnapshot {
                let books = querySS.documents.compactMap { doc -> Book? in
                    let data = doc.data()
                    guard let name = data["name"] as? String, let url = data["imageUrl"] as? String, let bookColor = data["color"] as? String, let uuidString = UUID(uuidString: doc.documentID) else {return nil}
                    let book = Book(name: name, id: uuidString, imageURL: url, bookColor: bookColor)
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

    func addBookImage(_ user: User, book: Book, new: Bool) {
        guard let imageData = book.image else {return}
        let storageRef = storage.reference()
        let imageRef = storageRef.child(book.id.uuidString)
        imageRef.putData(imageData, metadata: nil) {metaData, error in
            imageRef.downloadURL { url, err in
                if let err = err {
                    print(err.localizedDescription)
                } else if let url = url{
                    if new {
                        self.addBook(user, book: book, imageUrl: url.absoluteString)
                    } else {
                        self.updateBook(book: book, imageURL: url.absoluteString)
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

    func deleteBook(book: Book) {
        guard let user = UserControllerAuth.shared.user else {return}
        let albumDirectory = usersDirectory.document(user.id).collection("Album")
        if book.imageURL != " " {
            deleteBookImage(book: book)
        }
        albumDirectory.document(book.id.uuidString).delete()
    }

    func updateBook(book: Book, imageURL: String = " ") {
        guard let user = UserControllerAuth.shared.user else {return}
        let albumDierectory = usersDirectory.document(user.id).collection("Album")
        albumDierectory.document(book.id.uuidString).updateData([
            "name": book.name,
            "imageUrl": imageURL,
            "color": book.bookColor
        ])
        //delegate?.booksUpdated()
        //print("Updated Book")
    }

    func addBook(_ user: User, book: Book, imageUrl: String = " ") {
        let albumDirectory = usersDirectory.document(user.id).collection("Album")
        albumDirectory.document(book.id.uuidString).setData([
            "name": book.name,
            "imageUrl": imageUrl,
            "color": book.bookColor
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
}
