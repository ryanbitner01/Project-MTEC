
//  RecipeController.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/11/21.
//

import Foundation
import UIKit

enum RecipeControllerError: Error {
    case unkown
    case noImage
}

extension RecipeControllerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unkown:
            return "Uknown Error has occured"
        case .noImage:
            return "No Image with the given URL found."
        }
    }
}

class RecipeController {
    static let shared = RecipeController()
    
    private init() {
        
    }
    
    func fetchRecipes(book: Book, completion: @escaping (Result<[Recipe], RecipeControllerError>) -> Void) {
        guard let user = UserControllerAuth.shared.user else {return}
        let book = db.collection("Users").document(user.id).collection("Album").document(book.id.uuidString)
        
        book.collection("Recipes").getDocuments { qs, err in
            if let qs = qs {
                let recipes = qs.documents.compactMap { doc -> Recipe? in
                    let data = doc.data()
                    let id = doc.documentID
                    guard let name = data["name"] as? String, let imageURL = data["imageURL"] as? String, let uuidFString = UUID(uuidString: id) else {return nil}
                    let recipe = Recipe(id: uuidFString, name: name, imageURL: imageURL)
                    return recipe
                }
                completion(.success(recipes))
            } else {
                completion(.failure(.unkown))
            }
        }
    }
    
    func getRecipeImage(url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let url = URL(string: url)
        guard let url = url, let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) else {
            completion(.failure(RecipeControllerError.noImage))
            return
        }
        completion(.success(image))
    }
    
    func addRecipeImage(recipe: Recipe, book: Book, instructions: [Instruction]?) {
        guard let imageData = recipe.image else {return}
        let storageRef = storage.reference()
        let imageRef = storageRef.child(recipe.id.uuidString)
        imageRef.putData(imageData, metadata: nil) {metaData, error in
            imageRef.downloadURL { url, err in
                if let err = err {
                    print(err.localizedDescription)
                } else if let url = url{
                    self.addRecipe(recipe: recipe, book: book, imageURL: url.absoluteString, instructions: instructions)
                }
            }
        }
        

    }
    
    func addRecipe(recipe: Recipe, book: Book, imageURL: String = "", instructions: [Instruction]?) {
        guard let user = UserControllerAuth.shared.user else {return}
        
        let recipeDirectory = db.collection("Users").document(user.id).collection("Album").document(book.id.uuidString).collection("Recipes")
            
        recipeDirectory.document(recipe.id.uuidString).setData([
            "name": recipe.name,
            "imageURL": imageURL
        ])
        
        if let instructions = instructions {
            for instruction in instructions {
                addInstruction(instruction: instruction, book: book, recipe: recipe)
            }
        }
    }
    
    func addInstruction(instruction: Instruction, book: Book, recipe: Recipe) {
        guard let user = UserControllerAuth.shared.user else {return}
        let recipeDirectory = db.collection("Users").document(user.id).collection("Album").document(book.id.uuidString).collection("Recipes").document(recipe.id.uuidString)
        recipeDirectory.collection("Instructions").document("\(instruction.order)").setData([
            "Description": instruction.descrtiption
        ])
    }
}
