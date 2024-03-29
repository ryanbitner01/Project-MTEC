//
//  BookDetailViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/1/21.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    //var recipes: [Recipe] = []
    var book: Book?
    var bookCover: BookCover?
    
    @IBOutlet weak var createRecipeLabel: UILabel!
    @IBOutlet weak var recipeCollectionView: UICollectionView!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeCollectionView.dataSource = self
        checkShared()
        getBook()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func getBook() {
        guard let bookCover = bookCover else {return}
        BookController.shared.getBook(bookCover: bookCover, path: .album, email: bookCover.owner) { result in
            switch result {
            case .success(let book):
                self.book = book
                DispatchQueue.main.async {
                    self.updateUI()
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func updateUI() {
        getRecipes()
        bookNameLabel.text = book?.name
        setupBookImage()
    }
    
    @IBSegueAction func segueToRecipeDetailViewController(_ coder: NSCoder, sender: Any?) -> RecipeDetailViewController? {
        guard let cell = sender as? RecipeCell, let indexPath = recipeCollectionView.indexPath(for: cell), let book = book else {return nil}
        let recipeDetailVC = RecipeDetailViewController(coder: coder)
        recipeDetailVC?.book = book
        recipeDetailVC?.recipe = book.recipes[indexPath.row]
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
    
    func checkShared() {
        guard let bookCover = bookCover else {return}
        let owner = BookController.shared.isOwner(book: bookCover)
        if !owner {
            deleteButton.isHidden = true
            shareButton.isHidden = true
            editButton.isHidden = true
            addButton.isHidden = true
            createRecipeLabel.isHidden = true
        }
    }
    
    func getRecipes() {
        guard let book = book else {return}
        RecipeController.shared.fetchRecipes(book: book, path: .album, email: book.owner) { result in
            switch result {
            case .success(let recipes):
                self.book?.recipes = recipes
                DispatchQueue.main.async {
                    self.recipeCollectionView.reloadData()
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func setupBookImage() {
        imageView.layer.cornerRadius = 25
        
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
        guard let user = UserControllerAuth.shared.user, let recipe = sourceViewController.recipe, let book = book else {return}
        RecipeController.shared.deleteRecipe(recipe: recipe, book: book, path: .album, email: user.id)
        if let recipeIndex = book.recipes.firstIndex(where: {$0.id == recipe.id}) {
            self.book?.recipes.remove(at: recipeIndex)
            recipeCollectionView.reloadData()
        }
        // Use data from the view controller which initiated the unwind segue
    }
    
    @IBAction func cancelUnwind(_ unwindSegue: UIStoryboardSegue) {
        print("CANCEL")
        // Use data from the view controller which initiated the unwind segue
    }
    
    @IBAction func saveBookUnwind(_ unwindSegue: UIStoryboardSegue) {
       
    }
    
    @IBAction func unwindFromShareBook(_ unwindSegue: UIStoryboardSegue) {
        print("Share")
        // Use data from the view controller which initiated the unwind segue
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete Book", message: "Are you sure you want to delete this book?", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {action in
            self.performSegue(withIdentifier: "DELETE", sender: self)
        })
        alertController.addAction(cancel)
        alertController.addAction(deleteAction)
        alertController.popoverPresentationController?.sourceView = self.view
        present(alertController, animated: true, completion: nil)
        
        alertController.popoverPresentationController?.sourceView = deleteButton
        alertController.popoverPresentationController?.sourceRect = deleteButton.bounds
    }
    @IBSegueAction func segueToShare(_ coder: NSCoder) -> ShareBookViewController? {
        let shareBookVC = ShareBookViewController(coder: coder)
        shareBookVC?.book = self.book
        return shareBookVC
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
        book?.recipes.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        cell.recipe = book?.recipes[indexPath.row]
        cell.updateCell()
        return cell
        
    }
}
