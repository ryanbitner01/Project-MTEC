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
    var requested: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        if let profile = profile, let requests = UserControllerAuth.shared.profile?.requests, requests.contains(profile.email) {
            requested = true
        }
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
    
    func setupUI() {
        profileView.layer.cornerRadius = 25
        nameLabel.text = profile?.name
        profileImage.image = profile?.image
        updateRequestButton()
    }
    
    func updateRequestButton() {
        switch requested {
        case true:
            requestButton.setTitle("Cancel Request", for: .normal)
        case false:
            requestButton.setTitle("Send Friend Request", for: .normal)
        }
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func requestButtonPressed(_ sender: Any) {
        switch requested {
        case true:
            // DENY Request
            guard let email = profile?.email else {return}
            SocialController.shared.denyRequest(otherUser: email) { err in
                if let err = err {
                    print(err.localizedDescription)
                }
            }
            DispatchQueue.main.async {
                self.requested.toggle()
                self.updateRequestButton()
            }
        
        case false:
            DispatchQueue.main.async {
                self.requested.toggle()
                self.updateRequestButton()
            }
            guard let email = profile?.email else {return}
            SocialController.shared.sendFriendRequest(user: email) { err in
                if let err = err {
                    print(err)
                } else {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
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
