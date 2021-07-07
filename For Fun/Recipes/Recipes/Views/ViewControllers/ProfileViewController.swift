//
//  ProfileViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/28/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        guard let email = UserControllerAuth.shared.user?.id else {return}
        getProfile(email: email)
    }
    
    func getProfile(email: String) {
        SocialController.shared.getProfileFromEmail(email: email) { result in
            switch result {
            case .success(let profile):
                self.setupImage(profile: profile)
                self.nameLabel.text = profile.name
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func setupImage(profile: Profile) {
        UserControllerAuth.shared.getProfilePic(profile: profile) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.profileImageView.image = data
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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

