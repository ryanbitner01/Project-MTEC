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
        case pendingShare
    }
    
    var book: Book?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPendingShare()
    }
    
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
        sharingCollectionView.reloadData()
    }
    
    func getPendingShare() {
        SharingController.shared.getSentShareRequests { requests in
            if let requests = requests {
                UserControllerAuth.shared.user?.shareRequestsSent = requests
                DispatchQueue.main.async {
                    self.setupPeople()
                    self.sharingCollectionView.reloadData()
                }
            } else {
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
            if let book = book, sharedWith.contains(user) || sentShared.contains(where: {$0.user == user && $0.bookName == book.name}) {
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
    
    func revokeRequest(profile: Profile) {
        guard let request = UserControllerAuth.shared.user?.shareRequestsSent.first(where: {$0.bookName == book?.name && $0.user == profile.email}), let book = book else {return print("No request Found")}
        SharingController.shared.revokeShareRequest(profile: profile, request: request, book: book)
    }
    
    func displayCancelShareAlertController(user: Profile, cell: PersonCollectionViewCell) {
        let alertController = UIAlertController(title: "Cancel Share", message: "Are you sure you would like to revoke your share request with \(user.name)?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let shareAction = UIAlertAction(title: "Revoke", style: .destructive, handler: {action in
            guard let profile = cell.profile else {return}
            self.revokeRequest(profile: profile)
        })
        alertController.addAction(shareAction)
        present(alertController, animated: true, completion: nil)
        alertController.popoverPresentationController?.sourceView = cell
        alertController.popoverPresentationController?.sourceRect = cell.bounds
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
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = SharingSection(rawValue: section) else {return 0}
        switch section {
        case .availableFriends:
            return availableFriends.count
        case .sharedWith:
            return sharedWith.count
        case .pendingShare:
            return UserControllerAuth.shared.user?.shareRequestsSent.count ?? 0
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
        case .pendingShare:
            if let pendingShare = UserControllerAuth.shared.user?.shareRequestsSent {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as! PersonCollectionViewCell
                let person = pendingShare[indexPath.row]
                cell.email = person.user
                cell.getProfile()
                return cell
            } else {
                return UICollectionViewCell()
            }
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
        case .pendingShare:
            let cell = collectionView.cellForItem(at: indexPath) as! PersonCollectionViewCell
            if let profile = cell.profile {
                displayCancelShareAlertController(user: profile, cell: cell)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = SharingSection(rawValue: indexPath.section)!
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! SectionHeader
        switch section {
        case .availableFriends:
            if availableFriends.count == 0 {
                sectionHeader.sectionTitleLabel.text = ""
            } else {
                sectionHeader.sectionTitleLabel.text = "Available Friends"
            }
        case .sharedWith:
            if sharedWith.count == 0 {
                sectionHeader.sectionTitleLabel.text = ""
            } else {
                sectionHeader.sectionTitleLabel.text = "Shared With"
            }
        case .pendingShare:
            if let pendingShare = UserControllerAuth.shared.user?.shareRequestsSent, pendingShare.count == 0 {
                sectionHeader.sectionTitleLabel.text = ""
            } else {
                sectionHeader.sectionTitleLabel.text = "Pending Share"
            }
        }
        
        return sectionHeader
    }

    
    
}
