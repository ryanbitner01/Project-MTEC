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
    
    var shareToProfile: Profile?
    
    enum SharingSection: Int, CaseIterable {
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
    
    func getPendingShare() {
        SharingController.shared.getSentShareRequests { requests in
            if let requests = requests {
                UserControllerAuth.shared.user?.shareRequestsSent = requests
                DispatchQueue.main.async {
                    self.setupPeople()
                    self.sharingCollectionView.reloadData()
                }
            }
        }
    }
    
    func getAvailableShare() {
        guard let profile = UserControllerAuth.shared.profile, let sentShared = UserControllerAuth.shared.user?.shareRequestsSent else {return}
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
    
    func showAlert(message: SharingError) {
        alertLabel.isHidden = false
        alertLabel.text = message.localizedDescription
    }
    
    func hideAlert() {
        alertLabel.isHidden = true
    }
    
    func shareBook(profile: Profile) {
        guard let book = book else {return}
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
    
    func displaySharingAlertController(user: Profile, cell: PersonCollectionViewCell) {
        let alertController = UIAlertController(title: "Share with user", message: "Would you like to share with \(user.name)?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: {action in
            guard let profile = cell.profile else {return}
            self.shareBook(profile: profile)
            self.navigationController?.popViewController(animated: true)
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
        guard let section = SharingSection(rawValue: section) else {return 0}
        switch section {
        case .availableFriends:
            return availableFriends.count
        case .sharedWith:
            return sharedWith.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = SharingSection(rawValue: indexPath.section) else {return UICollectionViewCell()}
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
        guard let section = SharingSection(rawValue: indexPath.section) else {return}
        switch section {
        case .availableFriends:
            let cell = collectionView.cellForItem(at: indexPath) as! PersonCollectionViewCell
            guard let shareToProfile = cell.profile else {return}
            displaySharingAlertController(user: shareToProfile, cell: cell)
            
        case .sharedWith:
            print("Unshare")
        // Action sheet to unshare
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = SharingSection(rawValue: indexPath.section)!
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! SectionHeader
        switch section {
        case .availableFriends:
            sectionHeader.sectionTitleLabel.text = "Available Friends"
        case .sharedWith:
            sectionHeader.sectionTitleLabel.text = "Shared With"
        }
        return sectionHeader
    }

    
    
}
