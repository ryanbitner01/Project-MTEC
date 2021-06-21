//
//  BooksCollectionViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/10/21.
//

import UIKit

class BooksViewController: UIViewController {
    
    enum Section: Int, CaseIterable {
        case notShared
        case shared
    }
    
    @IBOutlet weak var bookCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookCollectionView.dataSource = self
        getRecipeBooks()
        getSharedbook()
    }
    
    func getSharedbook() {
        guard let user = UserControllerAuth.shared.user else {return}
        BookController.shared.getBooks(user: user, path: .sharedAlbum) { result in
            switch result {
            case .success(let books):
                UserControllerAuth.shared.user?.sharedAlbum = books
                print("got shared books")
                DispatchQueue.main.async {
                    self.bookCollectionView.reloadData()
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func getRecipeBooks() {
        guard let user = UserControllerAuth.shared.user else {return}
        BookController.shared.getBooks(user: user, path: .album) { result in
            switch result {
            case .success(let books):
                UserControllerAuth.shared.user?.album = books
                print("GOT BOOKS")
                DispatchQueue.main.async {
                    self.bookCollectionView.reloadData()
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    @IBAction func deleteBookUnwind(_ unwindSegue: UIStoryboardSegue) {
        if let bookDetailVC = unwindSegue.source as? BookDetailViewController, unwindSegue.identifier == "DELETE" {
            guard let book = bookDetailVC.book else {return}
            let recipes = bookDetailVC.book?.recipes ?? []
            for recipe in recipes {
                RecipeController.shared.deleteRecipe(recipe: recipe, book: book, path: .album)
            }
            for user in book.sharedUsers {
                BookController.shared.deleteBook(book: book, path: .otherSharedAlbum, email: user) { err in
                    if let err = err {
                        print(err.localizedDescription + user)
                    }
                }
            }
            if book.image != nil {
                BookController.shared.deleteBookImage(book: book)
            }
            BookController.shared.deleteBook(book: book, path: .album) {err in
                if let err = err {
                    print(err.localizedDescription + book.name)
                    return
                }
            }
            if let indexPath = UserControllerAuth.shared.user?.album.firstIndex(where: {$0.id == book.id}) {
                UserControllerAuth.shared.user?.album.remove(at: indexPath)
                self.bookCollectionView.reloadData()
            }
            
        }
    }
    
    @IBAction func unwindToBooks(_ unwindSegue: UIStoryboardSegue) {
        if let newBookVC = unwindSegue.source as? NewBookViewController, let newBook = newBookVC.book {
            if let existingIndex = UserControllerAuth.shared.user?.album.firstIndex(where: {$0.id == newBook.id}) {
                UserControllerAuth.shared.user?.album[existingIndex] = newBook
                bookCollectionView.reloadData()
            } else {
                UserControllerAuth.shared.user?.album.append(newBook)
                bookCollectionView.reloadData()
            }
        }
        //        if let bookDetailVC = unwindSegue.source as? BookDetailViewController, unwindSegue.identifier == "DELETE" {
        //            guard let book = bookDetailVC.book else {return}
        //            let recipes = bookDetailVC.recipes
        //            for recipe in recipes {
        //                RecipeController.shared.deleteRecipe(recipe: recipe, book: book)
        //            }
        //
        //            if book.image != nil {
        //                BookController.shared.deleteBookImage(book: book)
        //            }
        //            BookController.shared.deleteBook(book: book) {err in
        //                if let err = err {
        //                    print(err.localizedDescription + book.name)
        //                    return
        //                }
        //            }
        //            if let indexPath = self.books.firstIndex(where: {$0.id == book.id}) {
        //                self.books.remove(at: indexPath)
        //                self.bookCollectionView.reloadData()
        //            }
        //
        //        }
        // Use data from the view controller which initiated the unwind segue
    }
    
    @IBSegueAction func segueToBookDetailVC(_ coder: NSCoder, sender: Any) -> BookDetailViewController? {
        let bookDetailVC = BookDetailViewController(coder: coder)
        guard let cell = sender as? BookCell, let book = cell.book else {return nil}
        bookDetailVC?.book = book
        return bookDetailVC
    }
}

extension BooksViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let section = Section(rawValue: section) else {return 0}
        switch section {
        case .notShared:
            return UserControllerAuth.shared.user?.album.count ?? 0
        case .shared:
            return UserControllerAuth.shared.user?.sharedAlbum.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = Section(rawValue: indexPath.section)!
        
        switch section {
        case .notShared:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
            let book = UserControllerAuth.shared.user?.album[indexPath.row]
            cell.book = book
            cell.updateCell()
            return cell
        case .shared:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
            let book = UserControllerAuth.shared.user?.sharedAlbum[indexPath.row]
            cell.book = book
            cell.updateCell()
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = Section(rawValue: indexPath.section)!
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! SectionHeader
        switch section {
        case .notShared:
            sectionHeader.sectionTitleLabel.text = "Owned"
        case .shared:
            sectionHeader.sectionTitleLabel.text = "Not Owned"
        }
        return sectionHeader
    }
    
    
}
