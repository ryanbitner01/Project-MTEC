//
//  MigrationController.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/23/21.
//

import Foundation

let testingEnabled = true

enum MigrationError: Error {
    case passwordChange
}

extension MigrationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .passwordChange:
            return "The password could not be changed, please try again."
        }
    }
}

class MigrationController {
    
    static let shared = MigrationController()
    
    private init() {
        
    }
    
    //MARK: Email Change
    // Changes the document in firestore associated with the email
    
    func changeEmail(new: String) {
        guard let user = UserControllerAuth.shared.user else {return}
        guard let newUser = newUser(new: new) else {return}
        newDirectory(user: user, new: newUser)
        deleteDirectory(user: user, new: newUser)
        auth.currentUser?.updateEmail(to: new, completion: { err in
            if let err = err  {
                print(err)
            }
        })
        UserControllerAuth.shared.user = newUser
    }
    
    func newUser(new: String) -> User? {
        if let user = UserControllerAuth.shared.user {
            return User(id: new, album: user.album, sharedAlbum: user.sharedAlbum, displayName: user.displayName)
        } else {
            return nil
        }
    }
    
    func newDirectory(user: User, new: User) {
        for book in user.album {
            BookController.shared.addBook(book: book, path: .newAlbum, email: new.id)
            for recipe in book.recipes {
                RecipeController.shared.addRecipe(recipe: recipe, book: book, instructions: recipe.instruction, ingredients: recipe.ingredients, path: .newAlbum, email: new.id)
            }
        }
    }
    
    func deleteDirectory(user: User, new: User) {
        for book in user.album {
            // delete the book from old alum
            book.owner = new.id
            BookController.shared.deleteBook(book: book, path: .album) { err in
                if let err = err {
                    print(err.localizedDescription)
                }
            }
            for user in book.sharedUsers {
                // delete shared books
                BookController.shared.deleteBook(book: book, path: .otherSharedAlbum, email: user) { err in
                    if let err = err {
                        print(err.localizedDescription + user)
                    }
                }
                // Reshare the book
                reshare(book: book, email: user)
            }
        }
    }
    
    func reshare(book: Book, email: String) {
        BookController.shared.addBook(book: book, imageUrl: book.imageURL ?? "", path: .otherSharedAlbum, email: email)
        for recipe in book.recipes {
            RecipeController.shared.addRecipe(recipe: recipe, book: book, imageURL: book.imageURL ?? "", instructions: recipe.instruction, ingredients: recipe.ingredients, path: .otherSharedAlbum, email: email)
        }
        BookController.shared.updateSharedUsers(users: book.sharedUsers, book: book)
    }
    
    //MARK: Password Change
    // Changes the password in Authentication
    
    func changePassword(new: String, completion: @escaping (MigrationError?) -> Void) {
        auth.currentUser?.updatePassword(to: new, completion: { err in
            if let err = err {
                print(err.localizedDescription)
                completion(.passwordChange)
            } else {
                completion(nil)
            }
        })
    }
}
