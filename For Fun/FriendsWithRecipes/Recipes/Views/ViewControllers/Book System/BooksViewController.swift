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
        case pendingShare
    }
    
    @IBOutlet weak var bookCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookCollectionView.dataSource = self
        bookCollectionView.delegate = self
        getRecipeBookCovers()
        getShareRequests()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSharedBookCovers()
    }
    
    func getShareRequests() {
        SharingController.shared.getShareRequests { result in
            if let result = result {
                UserControllerAuth.shared.user?.shareRequests = result
                DispatchQueue.main.async {
                    self.bookCollectionView.reloadData()
                }
            }
        }
    }
    
    //    func getSharedBook() {
    //        guard let user = UserControllerAuth.shared.user else {return}
    //        BookController.shared.getBooks(user: user, path: .sharedAlbum) { result in
    //            switch result {
    //            case .success(let books):
    //                UserControllerAuth.shared.user?.sharedAlbum = books
    //                print("got shared books")
    //                DispatchQueue.main.async {
    //                    self.bookCollectionView.reloadData()
    //                }
    //            case .failure(let err):
    //                print(err.localizedDescription)
    //            }
    //        }
    //    }
    
    func getSharedBookCovers() {
        guard let user = UserControllerAuth.shared.user else {return}
        SharingController.shared.getSharedBookCovers { result in
            switch result {
            case .success(let bookCovers):
                user.sharedAlbum = bookCovers
                DispatchQueue.main.async {
                    self.bookCollectionView.reloadData()
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func getRecipeBookCovers() {
        guard let user = UserControllerAuth.shared.user else {return}
        BookController.shared.getBookCovers { result in
            switch result {
            case .success(let bookCovers):
                user.album = bookCovers
                DispatchQueue.main.async {
                    self.bookCollectionView.reloadData()
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    //    func getRecipeBooks() {
    //        guard let user = UserControllerAuth.shared.user else {return}
    //        BookController.shared.getBooks(user: user, path: .album) { result in
    //            switch result {
    //            case .success(let books):
    //                UserControllerAuth.shared.user?.album = books
    //                //print("GOT BOOKS")
    //                DispatchQueue.main.async {
    //                    self.bookCollectionView.reloadData()
    //                }
    //            case .failure(let err):
    //                print(err.localizedDescription)
    //            }
    //        }
    //    }
    
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
            BookController.shared.deleteBook(book: book, path: .album, email: book.owner) {err in
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
            //            if let existingIndex = UserControllerAuth.shared.user?.album.firstIndex(where: {$0.id == newBook.id}) {
            //                UserControllerAuth.shared.user?.album[existingIndex] = newBook
            //                bookCollectionView.reloadData()
            //            } else {
            //                UserControllerAuth.shared.user?.album.append(newBook)
            //                bookCollectionView.reloadData()
            //            }
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
        bookDetailVC?.bookCover = book
        return bookDetailVC
    }
}

extension BooksViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let section = Section(rawValue: section) else {return 0}
        switch section {
        case .notShared:
            return UserControllerAuth.shared.user?.album.count ?? 0
        case .shared:
            return UserControllerAuth.shared.user?.sharedAlbum.count ?? 0
        case .pendingShare:
            return UserControllerAuth.shared.user?.shareRequests.count ?? 0
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
        case .pendingShare:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookShareCell", for: indexPath) as! BookShareCell
            let request = UserControllerAuth.shared.user?.shareRequests[indexPath.row]
            cell.bookShareRequest = request
            cell.updateCell()
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = Section(rawValue: indexPath.section)!
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! SectionHeader
        switch section {
        case .notShared:
            sectionHeader.sectionTitleLabel.text = "My Books"
        case .shared:
            sectionHeader.sectionTitleLabel.text = "Friends Books"
        case .pendingShare:
            if UserControllerAuth.shared.user?.shareRequests.count != 0 {
                sectionHeader.sectionTitleLabel.text = "Share Requests"
            } else {
                sectionHeader.sectionTitleLabel.text = ""
            }
        }
        return sectionHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = Section(rawValue: indexPath.section)!
        if section == .pendingShare {
            guard let cell = bookCollectionView.cellForItem(at: indexPath) as? BookShareCell else {return}
            displaySharingActionSheet(cell: cell)
        }
    }
    
    func displaySharingActionSheet(cell: BookShareCell) {
        guard let request = cell.bookShareRequest else {return}
        let userName = request.ownerProfile?.name ?? ""
        let bookName = request.bookName
        let alertController = UIAlertController(title: "\(bookName)", message: "\(userName) has requested to share this book with you. Would you like to accept?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let acceptAction = UIAlertAction(title: "Accept", style: .default, handler: {action in
            SharingController.shared.acceptRequest(shareRequest: request)
        })
        
        let declineAction = UIAlertAction(title: "Decline", style: .destructive, handler: {action in
            SharingController.shared.declineRequest(shareRequest: request)
        })
        alertController.addAction(acceptAction)
        alertController.addAction(declineAction)
        present(alertController, animated: true, completion: nil)
        alertController.popoverPresentationController?.sourceView = cell
        alertController.popoverPresentationController?.sourceRect = cell.bounds
    }
    
    
}

extension Data {
    func prettyPrintedJSONString() {
        guard
            let jsonObject = try?
                JSONSerialization.jsonObject(with: self,
                                             options: []),
            let jsonData = try?
                JSONSerialization.data(withJSONObject:
                                        jsonObject, options: [.prettyPrinted]),
            let prettyJSONString = String(data: jsonData,
                                          encoding: .utf8) else {
                print("Failed to read JSON Object.")
                return
            }
        print(prettyJSONString)
    }
}
