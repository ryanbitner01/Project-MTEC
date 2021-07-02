//
//  ShareBookViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/16/21.
//

import UIKit

class ShareBookViewController: UIViewController {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var alertLabel: UILabel!
    
    var book: Book?
    
    override func viewDidLoad() {
        self.hideKeyboardTappedAround()
        super.viewDidLoad()
        self.hideKeyboardTappedAround()
        if let book = book {
            nameLabel.text = book.name
            for recipe in book.recipes {
                fetchIngredients(recipe: recipe)
                fetchInstructions(recipe: recipe)
            }
        }
        hideAlert()
        setupBookImage()
        // Do any additional setup after loading the view.
    }
    
    func setupBookImage() {
        if let image = book?.image {
            bookImageView.image = UIImage(data: image)
            
        } else {
            guard let imageUrl = book?.imageURL, imageUrl != "" else {
                bookImageView.image = UIImage(systemName: "book.closed.fill")
                if let book = book {
                    let color = UIColor(named: book.bookColor)
                    bookImageView.tintColor = color
                    return
                } else {
                    bookImageView.tintColor = .black
                }
                return
            }
            //imageView.image = UIImage(systemName: "book.closed.fill")
            BookController.shared.getBookImage(url: imageUrl) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.bookImageView.image = image
                        self.bookImageView.layer.cornerRadius = 25
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func shareBookPressed(_ sender: Any) {
        guard let book = book else {return}
        SharingController.shared.canShare(book: book, email: emailTextField.text!) { err in
            if let err = err {
                DispatchQueue.main.async {
                    self.showAlert(message: err)
                    return
                }
            } else {
                DispatchQueue.main.async {
                    self.hideAlert()
                    self.shareBook()
                    self.performSegue(withIdentifier: "Share", sender: self)
                }
            }
        }
    }
    
    func showAlert(message: SharingError) {
        alertLabel.isHidden = false
        alertLabel.text = message.localizedDescription
    }
    
    func hideAlert() {
        alertLabel.isHidden = true
    }
    
    func shareBook() {
        guard let book = book else {return}
        BookController.shared.addBook(book: book, imageUrl: book.imageURL ?? "", path: .otherSharedAlbum, email: emailTextField.text!)
        for recipe in book.recipes {
            RecipeController.shared.addRecipe(recipe: recipe, book: book, imageURL: book.imageURL ?? "", instructions: recipe.instruction, ingredients: recipe.ingredients, path: .otherSharedAlbum, email: emailTextField.text!)
        }
        book.sharedUsers.append(emailTextField.text!)
        BookController.shared.updateSharedUsers(users: book.sharedUsers, book: book)
    }
    
    func fetchInstructions(recipe: Recipe) {
        guard let user = UserControllerAuth.shared.user, let book = book else {return}
        RecipeController.shared.getInstructions(user: user, recipe: recipe, book: book, path: .album) { result in
            switch result {
            case .success(let steps):
                recipe.instruction = steps
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func fetchIngredients(recipe: Recipe) {
        guard let user = UserControllerAuth.shared.user, let book = book else {return}
        RecipeController.shared.getIngredients(user: user, recipe: recipe, book: book, path: .album) { result in
            switch result {
            case .success(let ingredients):
                recipe.ingredients = ingredients
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
