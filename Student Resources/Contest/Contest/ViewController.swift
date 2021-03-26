//
//  ViewController.swift
//  Contest
//
//  Created by Ryan Bitner on 3/26/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        guard emailTextField.text != "" else {
            shake()
            return
        }
        performSegue(withIdentifier: "contestSegue", sender: nil)
    }
    
    //MARK: Animations
    func shake() {
        UIView.animate(withDuration: 0.5) {
            self.emailTextField.transform = CGAffineTransform(translationX: 15, y: 0)
        } completion: { (_: Bool) in
            self.emailTextField.transform = .identity
        }
    }
    


}

