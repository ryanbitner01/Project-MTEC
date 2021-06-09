//
//  BookDetailViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/1/21.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    var recipes: [Recipe] = []
    var book: Book?
    
    @IBOutlet weak var recipeCollectionView: UICollectionView!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeCollectionView.dataSource = self
        if let book = book {
            bookNameLabel.text = book.name
            setupBookImage()
        }
        getRecipes()
        imageView.layer.cornerRadius = 25
        // Do any additional setup after loading the view.
    }
    @IBSegueAction func segueToRecipeDetailViewController(_ coder: NSCoder, sender: Any?) -> RecipeDetailViewController? {
        guard let cell = sender as? RecipeCell, let indexPath = recipeCollectionView.indexPath(for: cell) else {return nil}
        let recipeDetailVC = RecipeDetailViewController(coder: coder)
        recipeDetailVC?.book = book
        recipeDetailVC?.recipe = recipes[indexPath.row]
        return recipeDetailVC
    }
    
    @IBSegueAction func segueToNewRecipe(_ coder: NSCoder, sender: Any?) -> CreateRecipeViewController? {
        guard let book = self.book else {return nil}
        let createRecipeVC = CreateRecipeViewController(coder: coder)
        createRecipeVC?.book = book
        return createRecipeVC
    }
    @IBSegueAction func editBook(_ coder: NSCoder) -> NewBookViewController? {
        let newBookVC = NewBookViewController(coder: coder)
        guard let book = self.book else {return nil}
        newBookVC?.book = book
        if book.image != nil {
            newBookVC?.image = imageView.image
        }

        return newBookVC
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
                print(err)
            }
        }
    }
    
    func setupBookImage() {
        if let image = book?.image {
            imageView.image = UIImage(data: image)
            
        } else {
            guard let imageUrl = book?.imageURL, imageUrl != "" else {
                imageView.image = UIImage(systemName: "book.closed.fill")
                if let book = book {
                    let color = UIColor(named: book.bookColor)
                    imageView.tintColor = color
                    return
                } else {
                    imageView.tintColor = .black
                }
                return
            }
            //imageView.image = UIImage(systemName: "book.closed.fill")
            BookController.shared.getBookImage(url: imageUrl) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.imageView.image = image
                        self.imageView.layer.cornerRadius = 25
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func deleteRecipeUnwind(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as! RecipeDetailViewController
        guard let recipe = sourceViewController.recipe, let book = book else {return}
        RecipeController.shared.deleteRecipe(recipe: recipe, book: book)
        if let recipeIndex = recipes.firstIndex(where: {$0.id == recipe.id}) {
            recipes.remove(at: recipeIndex)
            recipeCollectionView.reloadData()
        }
        // Use data from the view controller which initiated the unwind segue
    }
    
    @IBAction func cancelUnwind(_ unwindSegue: UIStoryboardSegue) {
        print("CANCEL")
        // Use data from the view controller which initiated the unwind segue
    }
    
    @IBAction func saveBookUnwind(_ unwindSegue: UIStoryboardSegue) {
        if let sourceVC = unwindSegue.source as? CreateRecipeViewController {
            guard let recipe = sourceVC.recipe else {return}
            if let indexPath = recipes.firstIndex(where: {$0.id == recipe.id}) {
                recipes[indexPath] = recipe
            } else {
                recipes.append(recipe)
            }
            recipeCollectionView.reloadData()
        }
        // Use data from the view controller which initiated the unwind segue
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

extension BookDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        cell.recipe = recipes[indexPath.row]
        cell.updateCell()
        return cell
        
    }
}
