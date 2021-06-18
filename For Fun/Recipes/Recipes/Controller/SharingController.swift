//
//  SharingController.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/17/21.
//

import Foundation
import Firebase

class SharingController {
    
    let usersDirectory = db.collection("Users")
    static let shared = SharingController()
    
    func getSharedAlbum(completion: @escaping (Result<[Book], Error>) -> Void) {
        guard let user = UserControllerAuth.shared.user else {return}
        usersDirectory.document(user.id).collection("SharedAlbum").getDocuments { qs, err in
            if let qs = qs {
                let docs = qs.documents
                for doc in docs {
                    let email = doc.documentID
                    self.getSharedBook(email: email) { result in
                        switch result {
                        case .success(let books):
                            completion(.success(books))
                        case .failure(let err):
                            completion(.failure(err))
                        }
                    }
                }
            }
        }
    }
    
    func getSharedBook(email: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        guard let user = UserControllerAuth.shared.user else {return}
        usersDirectory.document(user.id).collection("SharedAlbum").document(email).getDocument { ds, err in
            if let ds = ds {
                guard let data = ds.data(),
                      let bookData = data["Books"] as? [Any] else {return}
                let books = self.getBookData(books: bookData)
                completion(.success(books))
            } else if let err = err {
                completion(.failure(err))
            }
        }
    }
    
    func getBookData(books: [Any]) -> [Book] {
        let books = books.compactMap { item -> Book? in
            guard let data = item as? [String: Any], let color = data["color"] as? String, let imageURL = data["imageUrl"] as? String, let name = data["name"] as? String, let recipesData = data["recipes"] as? [String: Any], let idString = data["id"] as? String, let id = UUID(uuidString: idString) else {return nil}
            let recipes = getRecipeData(recipes: recipesData)
            return Book(name: name, id: id, recipes: recipes, imageURL: imageURL, bookColor: color, isShared: true)
        }
        return books
    }
    
    func getRecipeData(recipes: [String: Any]) -> [Recipe] {
        let recipes = recipes.compactMap { item -> Recipe? in
            guard let data = item.value as? [String: Any], let id = UUID(uuidString: item.key), let imageULR = data["imageURL"] as? String, let name = data["name"] as? String, let ingredientsData = data["ingredients"] as? [String: Any], let stepData = data["steps"] as? [String: Any] else {return nil}
            let ingredients = getIngredientData(ingredients: ingredientsData)
            let steps = getStepData(steps: stepData)
            return Recipe(id: id, name: name, imageURL: imageULR, instruction: steps, ingredients: ingredients)
        }
        return recipes
    }
    
    func getStepData(steps: [String: Any]) -> [Step] {
        let steps = steps.compactMap { item -> Step? in
            guard let itemData = item.value as? [String: Any], let order = Int(item.key), let description = itemData["description"] as? String else {return nil}
            return Step(order: order, description: description)
        }
        return steps
    }
    
    func getIngredientData(ingredients: [String: Any]) -> [Ingredient] {
        print(ingredients)
        let ingredients = ingredients.compactMap { item -> Ingredient? in
            guard let ingredientData = item.value as? [String: Any], let count = Int(item.key), let name = ingredientData["name"] as? String, let partQuantity = ingredientData["partQuantity"] as? String, let quantity = ingredientData["quantity"] as? String, let unit = ingredientData["unit"] as? String else {return nil}
            return Ingredient(name: name, unit: unit, quantity: quantity, partQuantity: partQuantity, count: count)
        }
        return ingredients
    }
    
    func updateSharedUsers(book: Book) {
        guard let user = UserControllerAuth.shared.user else {return}
        let sharedUsers = usersDirectory.document(user.id).collection("Album").document(book.id.uuidString)
        sharedUsers.updateData([
            "SharedUsers": book.sharedUsers
        ])
    
    }
    
    func setupRecipeData(book: Book) -> [String: Any] {
        var bookData = [String: Any]()
        for recipe in book.recipes {
            let data: [String: Any] = [
                "imageURL": recipe.imageURL ?? "",
                "name": recipe.name,
                "ingredients": setupIngredientData(recipe: recipe),
                "steps": setupStepData(recipe: recipe)
            ]
            bookData["\(book.id.uuidString)"] = data
        }
        return bookData
    }
    
    func setupStepData(recipe: Recipe) -> [String: Any] {
        var data = [String: Any]()
        for step in recipe.instruction {
            let stepData: [String: String] = [
                "description": step.description
            ]
            data["\(step.order)"] = stepData
        }
        return data
    }
    
    func setupIngredientData(recipe: Recipe) -> [String: Any] {
        var data = [String: Any]()
        for ingredient in recipe.ingredients {
            let ingredientData: [String: String] = [
                "name": ingredient.name,
                "partQuantity": ingredient.partQuantity ?? "",
                "quantity": ingredient.quantity ?? "",
                "unit": ingredient.unit ?? ""
            ]
            data["\(ingredient.count)"] = ingredientData
        }
        return data
    }
    func shareBook(book: Book, email: String) {
        guard let user = UserControllerAuth.shared.user else {return}
        //updateSharedUsers(book: book)
        let bookData: [String: Any] = [
            "id": book.id.uuidString,
            "color": book.bookColor,
            "imageUrl": book.imageURL ?? "",
            "name": book.name,
            "recipes": setupRecipeData(book: book),
            "isShared": true
        ]
        usersDirectory.document(email).collection("SharedAlbum").document(user.id).updateData([
            "Books": FieldValue.arrayUnion([bookData])
        ]) { err in
            if err != nil {
                self.usersDirectory.document(email).collection("SharedAlbum").document(user.id).setData([
                    "Books": [bookData]
                ])
            }
        }
    }
}
