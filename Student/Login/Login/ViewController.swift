//
//  ViewController.swift
//  Login
//
//  Created by Ryan Bitner on 2/19/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var forgotUserButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? UIButton else {return}
        
        if sender == forgotPasswordButton {
            segue.destination.navigationItem.title = "Forgot Passoword"
        } else if sender == forgotUserButton {
            segue.destination.navigationItem.title = "Forgot Username"
        } else {
            segue.destination.navigationItem.title = userText.text
        }
    }
    
    @IBAction func forgotUserButton(_ sender: Any) {
        performSegue(withIdentifier: "progmaticSegue", sender: sender)
        
    }
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
        performSegue(withIdentifier: "progmaticSegue", sender: sender)
    }
    
}

