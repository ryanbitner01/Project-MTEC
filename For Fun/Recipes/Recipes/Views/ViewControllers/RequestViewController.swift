//
//  RequestViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 7/9/21.
//

import UIKit

class RequestViewController: UIViewController {

    @IBOutlet weak var requestView: UIView!
    @IBOutlet weak var denyButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePic: CircleImageView!
    
    var profile: Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
        nameLabel.text = profile?.name
        profilePic.image = profile?.image
        requestView.layer.cornerRadius = 25
    }
    
    @IBAction func denyPressed(_ sender: Any) {
        guard let profile = profile else {return}
        SocialController.shared.denyRequest(otherUser: profile.email) { err in
            if let err = err {
                print(err.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func acceptPressed(_ sender: Any) {
        guard let profile = profile else {return}
        SocialController.shared.acceptRequest(otherUser: profile.email) { err in
            if let err = err {
                print(err.localizedDescription)
                return
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
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
