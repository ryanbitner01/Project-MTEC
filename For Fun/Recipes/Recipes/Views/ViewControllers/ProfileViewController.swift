//
//  ProfileViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/28/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        // Do any additional setup after loading the view.
    }
    
    func setupImageView() {
        profileImageView.makeRound()
        //profileImageView.layer.borderWidth = 2
        //profileImageView.layer.borderColor = UIColor(named: "tintColor")?.cgColor
        profileImageView.layer.shadowRadius = 10
        profileImageView.layer.shadowColor = UIColor.lightGray.cgColor
        //profileImageView.contentMode = .scaleAspectFit
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

extension UIImageView {
    public func makeRound() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.width/2.1
        self.clipsToBounds = true
    }
}
