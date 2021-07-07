//
//  ProfileSnapshotViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 7/6/21.
//

import UIKit

class ProfileSnapshotViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var profileView: UIView!
    
    var profile: Profile?
    var email: String?
    var displayName: String?
    var requested: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setupUI() {
        profileView.layer.cornerRadius = 25
        getEmail()
    }
    
    func getEmail() {
        guard let displayName = displayName else {return}
        SocialController.shared.getEmailFromDisplayName(displayName: displayName) { result in
            switch result {
            case .success(let email):
                self.email = email
                self.getProfile()
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    func getProfile() {
        guard let email = email else {return}
        SocialController.shared.getProfileFromEmail(email: email) { result in
            switch result {
            case .success(let profile):
                self.profile = profile
                DispatchQueue.main.async {
                    self.getProfilePic()
                    self.nameLabel.text = profile.name
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func getProfilePic() {
        guard let profile = profile else {return}
        UserControllerAuth.shared.getProfilePic(profile: profile) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.profileImage.image = image
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
