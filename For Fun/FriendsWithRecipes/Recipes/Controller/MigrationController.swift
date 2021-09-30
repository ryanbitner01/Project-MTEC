//
//  MigrationController.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/23/21.
//

import Foundation
import Firebase

let testingEnabled = true

enum MigrationError: Error {
    case passwordChange
    case nameChange
    case invalidName
}

extension MigrationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .passwordChange:
            return "The password could not be changed, please try again."
        case .nameChange:
            return "The name could not be changed, either because the name has already been used or an uknown error has occured."
        case .invalidName:
            return "The name is already in use, please choose a different name."
        }
    }
}

class MigrationController {
    
    static let shared = MigrationController()
    
    var oldAlbum = [Book]()
    
    private init() {
        
    }
    
    func getUserPath() -> CollectionReference? {
        if testingEnabled {
            return db.collection("TestUsers")
        } else {
            return db.collection("Users")
        }
    }
    
    //MARK: Email Change
    // Changes the document in firestore associated with the email
    
    func changeName(new: String, completion: (MigrationError?) -> Void) {
        guard let path = getUserPath(), let user = UserControllerAuth.shared.user else {return completion(.nameChange)}
        completion(nil)
        path.document(user.id).updateData([
            "DisplayName": new
        ])
        
    }
    
    func changeEmail(new: String) {
        guard let user = UserControllerAuth.shared.user else {return}
        guard let newUser = newUser(new: new) else {return}
        getAlbum { didComplete in
            if didComplete {
                self.newDirectory(user: user, new: newUser)
                self.deleteDirectory(user: user, new: newUser)
            }
        }
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
    
    func getAlbum(completion: @escaping (Bool) -> Void) {
        guard let user = UserControllerAuth.shared.user else {return}
        BookController.shared.getBooks(user: user, path: .album, email: user.id) { result in
            switch result {
            case .success(let books):
                self.oldAlbum = books
            case.failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func getRecipes(completion: @escaping (Bool) -> Void) {
        for book in oldAlbum {
            RecipeController.shared.fetchRecipes(book: book, path: .album) { result in
                switch result {
                case .success(let recipes):
                    book.recipes = recipes
                    self.getIngredients(book: book) { didComplete in
                        completion(true)
                    }
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    func getIngredients(book: Book, completion: @escaping (Bool) -> Void) {
        guard let user = UserControllerAuth.shared.user else {return}
        for recipe in book.recipes {
            RecipeController.shared.getIngredients(user: user, recipe: recipe, book: book, path: .album) { result in
                switch result {
                case .success(let ingredients):
                    recipe.ingredients = ingredients
                    self.getSteps(book: book) { didComplete in
                        completion(true)
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        }
    }
    
    func getSteps(book: Book, completion: @escaping (Bool) -> Void) {
        guard let user = UserControllerAuth.shared.user else {return}
        for recipe in book.recipes {
            RecipeController.shared.getInstructions(user: user, recipe: recipe, book: book, path: .album) { result in
                switch result {
                case .success(let steps):
                    recipe.instruction = steps
                    completion(true)
                case .failure(let err):
                    print(err)
                    completion(false)
                }
            }
        }
    }
    
    func newDirectory(user: User, new: User) {
        for book in oldAlbum {
            let cover = BookCover(name: book.name, id: book.id, imageURL: book.imageURL ?? "", bookColor: book.bookColor, owner: book.owner)
            BookController.shared.addBook(book: cover, path: .album, email: new.id)
            for recipe in book.recipes {
                RecipeController.shared.addRecipe(recipe: recipe, book: book, instructions: recipe.instruction, ingredients: recipe.ingredients, path: .album, email: new.id)
            }
        }
    }
    
    func deleteDirectory(user: User, new: User) {
        for book in oldAlbum {
            // delete the book from old alum
            book.owner = new.id
            let cover = BookCover(name: book.name, id: book.id, imageURL: book.imageURL ?? "", bookColor: book.bookColor, owner: book.owner)

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
                let profile = Profile(name: "", email: user, imageURL: "", image: nil, friends: [], requests: [], pendingFriends: [])
                SharingController.shared.revokeBookShare(profile: profile, book: book)
                // Reshare the book
                reshare(email: user, cover: cover)
            }
        }
    }
    
    func reshare(email: String, cover: BookCover) {
        SharingController.shared.reshareBook(cover: cover, userID: email, shared: false)
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
