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
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var sharingCollectionView: UICollectionView!
    
    var availableFriends: [String] = []
    var sharedWith: [String] = []
    
    var shareToProfile: String?
    
    enum sharingSection: Int, CaseIterable {
        case availableFriends
        case sharedWith
    }
    
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardTappedAround()
        sharingCollectionView.delegate = self
        sharingCollectionView.dataSource = self
        if let book = book {
            nameLabel.text = book.name
            for recipe in book.recipes {
                fetchIngredients(recipe: recipe)
                fetchInstructions(recipe: recipe)
            }
        }
        hideAlert()
        setupBookImage()
        setupPeople()
        // Do any additional setup after loading the view.
    }
    
    func setupPeople() {
        getSharedWith()
        getAvailableShare()
    }
    
    func getAvailableShare() {
        guard let profile = UserControllerAuth.shared.profile else {return}
        let friends = profile.friends
        availableFriends = friends.compactMap({user -> String? in
            if sharedWith.contains(user) {
                return nil
            } else {
                return user
            }
        })
    }
    
    func getSharedWith() {
        guard let book = book else {return}
        sharedWith = book.sharedUsers
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
        if shareToProfile != nil {
            shareBook()
        } else {
            showAlert(message: .noUser)
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
        guard let book = book, let profile = UserControllerAuth.shared.profile else {return}
        SharingController.shared.sendShareRequest(book: book, profile: profile) { err in
            if let err = err {
                DispatchQueue.main.async {
                    self.showAlert(message: err)
                }
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
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
    
    func displaySharingAlertController(user: String, cell: PersonCollectionViewCell) {
        let alertController = UIAlertController(title: "Share With User \(user)", message: "Would you like to share with this user?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: {action in
            self.shareBook()
        })
        alertController.addAction(shareAction)
        present(alertController, animated: true, completion: nil)
        alertController.popoverPresentationController?.sourceView = cell
        alertController.popoverPresentationController?.sourceRect = cell.bounds
    }
}

extension ShareBookViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = sharingSection(rawValue: section) else {return 0}
        switch section {
        case .availableFriends:
            return availableFriends.count
        case .sharedWith:
            return sharedWith.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = sharingSection(rawValue: indexPath.section) else {return UICollectionViewCell()}
        switch section {
        case .availableFriends:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as! PersonCollectionViewCell
            let person = availableFriends[indexPath.row]
            cell.email = person
            cell.getProfile()
            return cell
        case .sharedWith:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as! PersonCollectionViewCell
            let person = sharedWith[indexPath.row]
            cell.email = person
            cell.getProfile()
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = sharingSection(rawValue: indexPath.section) else {return}
        switch section {
        case .availableFriends:
            let cell = collectionView.cellForItem(at: indexPath) as! PersonCollectionViewCell
            shareToProfile = cell.email
            
            
        case .sharedWith:
            print("Unshare")
        // Action sheet to unshare
        }
    }
    
    
}
