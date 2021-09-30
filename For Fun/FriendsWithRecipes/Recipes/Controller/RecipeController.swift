
//  RecipeController.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/11/21.
//

import Foundation
import UIKit
import Firebase

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
    let usersDirectory = db.collection("Users")
    
    private init() {
        
    }
    
    func fetchRecipes(book: Book, path: FireBasePath, email: String = "", completion: @escaping (Result<[Recipe], RecipeControllerError>) -> Void) {
        guard let path = getPath(path: path, email: email) else {return}
        path.document(book.id.uuidString).collection("Recipes").addSnapshotListener { qs, err in
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
    
    func getInstructions(user: User, recipe: Recipe, book: Book, path: FireBasePath, email: String = "", completion: @escaping (Result<[Step], Error>) -> Void) {
        guard let path = getPath(path: path, email: email) else {return}
        
        let recipeDirectory = path.document(book.id.uuidString).collection("Recipes").document(recipe.id.uuidString)
        let instructionsDoc = recipeDirectory.collection("Instructions")
        instructionsDoc.getDocuments { querySnapshot, err in
            if let err = err {
                completion(.failure(err))
            } else if let querySnapshot = querySnapshot {
                let instructions = querySnapshot.documents.compactMap { doc -> Step? in
                    let data = doc.data()
                    guard let description = data["Description"] as? String, let id = Int(doc.documentID) else {return nil}
                    let newStep = Step(order: id, description: description)
                    return newStep
                }
                completion(.success(instructions))
            }
        }
    }
    
    func getIngredients(user: User, recipe: Recipe, book: Book,path: FireBasePath, email: String = "", completion: @escaping (Result<[Ingredient], Error>) -> Void) {
        guard let path = getPath(path: path, email: email) else {return}
        
        let recipeDirectory = path.document(book.id.uuidString).collection("Recipes").document(recipe.id.uuidString)
        let ingredientsDoc = recipeDirectory.collection("Ingredients")
        ingredientsDoc.getDocuments { querySnapshot, err in
            if let err = err {
                completion(.failure(err))
            } else if let querySnapshot = querySnapshot {
                let ingredients = querySnapshot.documents.compactMap { doc -> Ingredient? in
                    let data = doc.data()
                    guard let id = Int(doc.documentID), let name = data["Name"] as? String, let unit = data["Unit"] as? String, let quantity = data["Quantity"] as? String, let partQuantity = data["PartQuantity"] as? String else {return nil}
                    let newIngredient = Ingredient(name: name, unit: unit, quantity: quantity, partQuantity: partQuantity ,count: id)
                    return newIngredient
                }
                completion(.success(ingredients))
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
    
    func addRecipeImage(recipe: Recipe, book: Book, instructions: [Step]?, ingredients: [Ingredient]?, path: FireBasePath, email: String = "") {
        guard let imageData = recipe.image else {return}
        let storageRef = storage.reference()
        let imageRef = storageRef.child(recipe.id.uuidString)
        imageRef.putData(imageData, metadata: nil) {metaData, error in
            imageRef.downloadURL { url, err in
                if let err = err {
                    print(err.localizedDescription)
                } else if let url = url{
                    self.addRecipe(recipe: recipe, book: book, imageURL: url.absoluteString, instructions: instructions, ingredients: ingredients, path: path, email: email)
                }
            }
        }
        
        
    }
    
    func addRecipe(recipe: Recipe, book: Book, imageURL: String = "", instructions: [Step]?, ingredients: [Ingredient]?, path: FireBasePath, email: String = "") {
        guard let directory = getPath(path: path, email: email) else {return}
        let recipeDirectory = directory.document(book.id.uuidString).collection("Recipes")
        
        recipeDirectory.document(recipe.id.uuidString).setData([
            "name": recipe.name,
            "imageURL": imageURL
        ])
        
        if let instructions = instructions {
            for instruction in instructions {
                addInstruction(instruction: instruction, book: book, recipe: recipe, path: path, email: email)
            }
        }
        
        if let ingredients = ingredients {
            for ingredient in ingredients {
                addIngredients(ingredient: ingredient, book: book, recipe: recipe, path: path, email: email)
            }
        }
    }
    
    func deleteInstruction(instruction: Step, book: Book, recipe: Recipe, path: FireBasePath, email: String = "") {
        guard let directory = getPath(path: path, email: email) else {return}
        let recipeDirectory = directory.document(book.id.uuidString).collection("Recipes").document(recipe.id.uuidString)
        recipeDirectory.collection("Instructions").document("\(instruction.order)").delete()
    }
    
    func deleteIngredient(ingredeint: Ingredient, book: Book, recipe: Recipe, path: FireBasePath, email: String = "") {
        guard let directory = getPath(path: path, email: email) else {return}
        let recipeDirectory = directory.document(book.id.uuidString).collection("Recipes").document(recipe.id.uuidString)
        recipeDirectory.collection("Ingredients").document("\(ingredeint.count)").delete()
    }
    
    func addInstruction(instruction: Step, book: Book, recipe: Recipe, path: FireBasePath, email: String = "") {
        guard let directory = getPath(path: path, email: email) else {return}
        let recipeDirectory = directory.document(book.id.uuidString).collection("Recipes").document(recipe.id.uuidString)
        recipeDirectory.collection("Instructions").document("\(instruction.order)").setData([
            "Description": instruction.description
        ])
    }
    
    func addIngredients(ingredient: Ingredient, book: Book, recipe: Recipe, path: FireBasePath, email: String = "") {
        guard let directory = getPath(path: path, email: email) else {return}
        let recipeDirectory = directory.document(book.id.uuidString).collection("Recipes").document(recipe.id.uuidString)
        recipeDirectory.collection("Ingredients").document("\(ingredient.count)").setData([
            "Name": ingredient.name,
            "Unit": ingredient.unit ?? "",
            "Quantity": ingredient.quantity ?? "",
            "PartQuantity": ingredient.partQuantity ?? ""
        ])
    }
    
    func deleteRecipe(recipe: Recipe, book: Book, path: FireBasePath, email: String = "") {
        guard let directory = getPath(path: path, email: email) else {return}
        
        guard let user = UserControllerAuth.shared.user else {return}
        let recipeDirectory = directory.document(book.id.uuidString).collection("Recipes").document(recipe.id.uuidString)
        if recipe.imageURL != " " {
            self.deleteRecipeImage(recipe: recipe)
        }
        getIngredients(user: user, recipe: recipe, book: book, path: path, email: email) { result in
            switch result {
            case .success(let ingredients):
                for ingredient in ingredients {
                    self.deleteIngredient(ingredeint: ingredient, book: book, recipe: recipe, path: path, email: email)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        getInstructions(user: user, recipe: recipe, book: book, path: path, email: email) { result in
            switch result {
            case .success(let steps):
                for step in steps {
                    self.deleteInstruction(instruction: step, book: book, recipe: recipe, path: path, email: email)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        recipeDirectory.delete()
    }
    
    func deleteRecipeImage(recipe: Recipe) {
        let storageRef = storage.reference()
        let imageRef = storageRef.child(recipe.id.uuidString)
        imageRef.delete { err in
            if let err = err {
                print(err.localizedDescription)
            } else {
                print("Image Deleted")
            }
        }
    }
}
