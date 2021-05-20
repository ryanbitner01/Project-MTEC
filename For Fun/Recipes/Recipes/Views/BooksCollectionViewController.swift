//
//  BooksCollectionViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/10/21.
//

import UIKit

private let reuseIdentifier = "BookCell"

class BooksCollectionViewController: UICollectionViewController {
    
    var books: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //BookController.shared.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getRecipeBooks()
        collectionView.reloadData()
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        getRecipeBooks()
        collectionView.reloadData()
    }
    
    func getRecipeBooks() {
        guard let user = UserControllerAuth.shared.user else {return}
        BookController.shared.getBooks(user: user) { result in
            switch result {
            case .success(let books):
                self.books = books
                print("GOT BOOKS")
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //guard let sharedUser = UserController.shared.user else {return 0}
        // #warning Incomplete implementation, return the number of items
        //print(sharedUser.album.count)
        return books.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //guard let sharedUser = UserController.shared.user else {return UICollectionViewCell()}
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BookCell
        let book = books[indexPath.row]
        cell.book = book
        cell.updateCell()
        
        return cell
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "segueToRecipeVC" {
//            let recipeVC = segue.destination as! RecipeViewController
//            guard let cell = sender as? BookCell, let indexPath = collectionView.indexPath(for: cell) else {return}
//            let book = books[indexPath.row]
//            recipeVC.book = book
//        }
//    }

    @IBSegueAction func segueToRecipeVC(_ coder: NSCoder, sender: Any?) -> RecipeViewController? {
        guard let cell = sender as? BookCell, let indexPath = collectionView.indexPath(for: cell) else {return nil}
        let recipeViewController = RecipeViewController(coder: coder)
        recipeViewController?.book = books[indexPath.row]
        return recipeViewController
    }
}

//extension BooksCollectionViewController: BookControllerDelegate {
//    func booksUpdated() {
//        getRecipeBooks()
//        //collectionView.reloadData()
//        print("BOOKS UPDATED")
//    }
//}
