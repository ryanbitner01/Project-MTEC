//
//  BooksCollectionViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/10/21.
//

import UIKit

class BooksViewController: UIViewController {
    
    @IBOutlet weak var bookCollectionView: UICollectionView!
    
    var books: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookCollectionView.dataSource = self
        getRecipeBooks()
    }
    
    func getRecipeBooks() {
        guard let user = UserControllerAuth.shared.user else {return}
        BookController.shared.getBooks(user: user) { result in
            switch result {
            case .success(let books):
                self.books = books
                print("GOT BOOKS")
                DispatchQueue.main.async {
                    self.bookCollectionView.reloadData()
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    @IBAction func unwindToBooks(_ unwindSegue: UIStoryboardSegue) {
        if let newBookVC = unwindSegue.source as? NewBookViewController, let newBook = newBookVC.book {
            if let existingIndex = books.firstIndex(where: {$0.id == newBook.id}) {
                books[existingIndex] = newBook
            } else {
                books.append(newBook)
                bookCollectionView.reloadData()
            }
        }
        if let bookDetailVC = unwindSegue.source as? BookDetailViewController, unwindSegue.identifier == "DELETE" {
            guard let book = bookDetailVC.book else {return}
            BookController.shared.deleteBook(book: book)
            if let indexPath = books.firstIndex(where: {$0.id == book.id}) {
                books.remove(at: indexPath)
                bookCollectionView.reloadData()
            }
        }
        // Use data from the view controller which initiated the unwind segue
    }
    
    @IBSegueAction func segueToBookDetailVC(_ coder: NSCoder, sender: Any) -> BookDetailViewController? {
        let bookDetailVC = BookDetailViewController(coder: coder)
        guard let cell = sender as? BookCell, let indexPath = bookCollectionView.indexPath(for: cell) else {return nil}
        bookDetailVC?.book = books[indexPath.row]
        return bookDetailVC
    }
}

extension BooksViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
        let book = books[indexPath.row]
        cell.book = book
        cell.updateCell()
        //cell.imageView.tintColor = getRandomColor(array: colors)
        //cell.nameLabel.text = names[indexPath.row]
        //cell.imageView.layer.cornerRadius = 15
        //cell.nameLabel.layer.borderColor = UIColor(named: "tintColor")?.cgColor
        //cell.nameLabel.layer.borderWidth = 2
        //cell.nameLabel.layer.cornerRadius = 10
        return cell
    }
    
    
}
