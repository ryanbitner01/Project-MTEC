//
//  ProfileViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/28/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    enum friendsSection: Int, CaseIterable {
        case friends
        case pendingFriends
        case sentFriends
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var friendsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsCollectionView.delegate = self
        friendsCollectionView.dataSource = self
        //getProfile()
        //updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getProfile()
    }
    
    func updateUI() {
        guard let profile = UserControllerAuth.shared.profile else {return}
        setupImage(profile: profile)
        nameLabel.text = profile.name
        
    }
    
    func getProfile() {
        guard let user = UserControllerAuth.shared.user else {return}
        SocialController.shared.getProfile(self: true, email: user.id) { profile in
            DispatchQueue.main.async {
                self.friendsCollectionView.reloadData()
                self.updateUI()
            }
        }
    }
    
    func setupImage(profile: Profile) {
        UserControllerAuth.shared.getProfilePic(profile: profile) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.profileImageView.image = UIImage(data: data)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    @IBAction func photoButtonTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Image Source", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let libraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(libraryAction)
        }
        
        alertController.popoverPresentationController?.sourceView = self.view
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBSegueAction func segueToRequestView(_ coder: NSCoder, sender: Any?) -> RequestViewController? {
        guard let sender = sender as? PersonCollectionViewCell else {return nil}
        let requestVC = RequestViewController(coder: coder)
        requestVC?.profile = sender.profile
        return requestVC
    }
    
    @IBSegueAction func segueToPersonView(_ coder: NSCoder, sender: Any?) -> ProfileSnapshotViewController? {
        guard let sender = sender as? PersonCollectionViewCell else {return nil}
        let profileSnapshotVC = ProfileSnapshotViewController(coder: coder)
        profileSnapshotVC?.profile = sender.profile
        return profileSnapshotVC
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

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let profile = UserControllerAuth.shared.profile ,let section = friendsSection(rawValue: section) else {return 0}
        switch section {
        case .friends:
            return profile.friends.count
        case .pendingFriends:
            return profile.pendingFriends.count
        case .sentFriends:
            return profile.requests.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let profile = UserControllerAuth.shared.profile, let section = friendsSection(rawValue: indexPath.section) else {return UICollectionViewCell()}
        switch section {
        case .friends:
            let friend = profile.friends[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as! PersonCollectionViewCell
            cell.email = friend
            cell.getProfile()
            return cell
        case .pendingFriends:
            let friend = profile.pendingFriends[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as! PersonCollectionViewCell
            cell.email = friend
            cell.getProfile()
            return cell
        case .sentFriends:
            let friend = profile.requests[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as! PersonCollectionViewCell
            cell.email = friend
            cell.getProfile()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = friendsSection(rawValue: indexPath.section)!
        guard let profile = UserControllerAuth.shared.profile else {return UICollectionReusableView()}
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! SectionHeader
        switch section {
        case .friends:
            if profile.friends.count == 0 {
                sectionHeader.sectionTitleLabel.text = ""
            } else {
                sectionHeader.sectionTitleLabel.text = "Friends"
            }
        case .pendingFriends:
            if profile.pendingFriends.count == 0 {
                sectionHeader.sectionTitleLabel.text = ""
            } else {
                sectionHeader.sectionTitleLabel.text = "Pending Friend Requests"
            }
        case .sentFriends:
            if profile.requests.count == 0 {
                sectionHeader.sectionTitleLabel.text = ""
            } else {
                sectionHeader.sectionTitleLabel.text = "Sent Requests"
            }
        }
        return sectionHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = friendsSection(rawValue: indexPath.section) else {return}
        guard let cell = collectionView.cellForItem(at: indexPath) else {return}
        switch section {
        case .friends:
            performSegue(withIdentifier: "PersonView", sender: cell)
        case .pendingFriends:
            performSegue(withIdentifier: "RequestView", sender: cell)
        case .sentFriends:
            performSegue(withIdentifier: "PersonView", sender: cell)
        }
    }
    
}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {return}
        guard let user = UserControllerAuth.shared.user, let imageData: Data = selectedImage.jpegData(compressionQuality: 0.9) else {return}
        UserControllerAuth.shared.user?.image = imageData
        UserControllerAuth.shared.addProfilePicture(user: user)
        profileImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
}

