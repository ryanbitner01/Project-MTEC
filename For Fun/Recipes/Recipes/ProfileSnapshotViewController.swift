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
    var status: ProfileStatus = .notRequested
    
    enum ProfileStatus {
        case requested
        case notRequested
        case friend
        case pendingRequest
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let profile = profile, let requests = UserControllerAuth.shared.profile?.requests, requests.contains(profile.email) {
            //requested = true
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
        updateStatus()
        updateRequestButton()
    }
    
    func updateStatus() {
        guard let selfProfile = UserControllerAuth.shared.profile, let profile = profile else {return}
        // Check if pending
        if selfProfile.pendingFriends.contains(profile.email) {
            status = .pendingRequest
        // Check if requested
        } else if selfProfile.requests.contains(profile.email) {
            status = .requested
        } else if selfProfile.friends.contains(profile.email) {
            status = .friend
        } else {
            status = .notRequested
        }
    }
    
    func updateRequestButton() {
        switch status {
        case .requested:
            requestButton.setTitle("Cancel Request", for: .normal)
        case .notRequested:
            requestButton.setTitle("Send Friend Request", for: .normal)
        case .friend:
            requestButton.setTitle("Unfriend", for: .normal)
        case .pendingRequest:
            requestButton.setTitle("Accept Friend", for: .normal)
        }
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func requestButtonPressed(_ sender: Any) {
        switch status {
        case .requested:
            // DENY Request
            guard let email = profile?.email else {return}
            SocialController.shared.denyRequest(otherUser: email) { err in
                if let err = err {
                    print(err.localizedDescription)
                }
            }
            DispatchQueue.main.async {
                self.updateRequestButton()
                self.dismiss(animated: true, completion: nil)
            }
        
        case .notRequested:
            DispatchQueue.main.async {
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
        case .friend:
            // Unfriend
            print("UnFriend")
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        case .pendingRequest:
            guard let email = profile?.email else {return}
            DispatchQueue.main.async {
                SocialController.shared.acceptRequest(otherUser: email) { err in
                    if let err = err {
                        return print(err.localizedDescription)
                    }
                }
            }
            dismiss(animated: true , completion: nil)
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
