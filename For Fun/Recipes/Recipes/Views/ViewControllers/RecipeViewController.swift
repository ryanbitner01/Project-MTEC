//
//  RecipeViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/11/21.
//

import UIKit

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var recipeCollectionView: UICollectionView!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var editBookButton: UIButton!
    @IBOutlet weak var bookNameLabel: UILabel!
    
    var book: Book?
    var recipes: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeCollectionView.dataSource = self
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    
    func updateUI() {
        getRecipes()
        getBookImage()
        bookNameLabel.text = book?.name
    }
    
    func getBookImage() {
        if let image = book?.image {
            self.bookImageView.image = UIImage(data: image)
            self.bookImageView.layer.cornerRadius = 25
        } else {
            guard let imageUrl = book?.imageURL, imageUrl != " " else {
                bookImageView.image = UIImage(systemName: "book.closed.fill")
                if let book = book {
                    let color = BookController.shared.getBookColor(book: book)
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
    @IBAction func deleteBookPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete Recipe Book", message: "Are you sure you want to delete this book, this action is permanent!", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {action in
            guard let book = self.book else {return}
            BookController.shared.deleteBook(book: book)
            self.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBSegueAction func segueToAddRecipe(_ coder: NSCoder, sender: Any?) -> CreateRecipeViewController? {
        let createRecipeVC = CreateRecipeViewController(coder: coder)
        createRecipeVC?.book = book
        return createRecipeVC
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBSegueAction func toEditVC(_ coder: NSCoder, sender: Any?) -> EditBookViewController? {
        let editBookVC = EditBookViewController(coder: coder)
        editBookVC?.book = self.book
        return editBookVC
    }
    
    @IBAction func unwindToRecipeVC(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as! EditBookViewController
        self.book = sourceViewController.book
        self.updateUI()
        guard let book = book, let user = UserControllerAuth.shared.user else {return}
        if book.image != nil {
            //Delete Old Image if there is one
            BookController.shared.deleteBookImage(book: book)
            // Add new image
            BookController.shared.addBookImage(user, book: book, new: false)
        } else {
            // else save color for system image
            BookController.shared.updateBook(book: book)
        }
        // Use data from the view controller which initiated the unwind segue
    }
    
    func getRecipes() {
        guard let book = book else {return}
        RecipeController.shared.fetchRecipes(book: book) { result in
            switch result {
            case .success(let recipes):
                self.recipes = recipes
                DispatchQueue.main.async {
                    self.recipeCollectionView.reloadData()
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
}

extension RecipeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        
        cell.recipe = recipes[indexPath.row]
        cell.updateCell()
        
        return cell
    }
    
    
}
