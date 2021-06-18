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
    
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let book = book {
            nameLabel.text = book.name
            for recipe in book.recipes {
                fetchIngredients(recipe: recipe)
                fetchInstructions(recipe: recipe)
            }
        }
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
        SharingController.shared.shareBook(book: book, email: emailTextField.text!)
        performSegue(withIdentifier: "Share", sender: self)
        
    }
    
    func fetchInstructions(recipe: Recipe) {
        guard let user = UserControllerAuth.shared.user, let book = book else {return}
        RecipeController.shared.getInstructions(user: user, recipe: recipe, book: book) { result in
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
        RecipeController.shared.getIngredients(user: user, recipe: recipe, book: book) { result in
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
