//
//  ViewController.swift
//  Lab - Basic Interactions
//
//  Created by Ryan Bitner on 2/3/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var myLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func setTextPressed(_ sender: Any) {
        myLabel.text = myTextField.text
    }
    @IBAction func clearButtonPressed(_ sender: Any) {
        myLabel.text = ""
        myTextField.text = ""
    }
    

}

