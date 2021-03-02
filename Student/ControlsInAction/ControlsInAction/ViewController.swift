//
//  ViewController.swift
//  ControlsInAction
//
//  Created by Ryan Bitner on 2/3/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func myButtonAction(_ sender: Any) {
        myLabel.text = "Button Tapped"
    }
    @IBAction func mySwitchToggled(_ sender: UISwitch) {
        if sender.isOn {
            myLabel.text = "The Switch is On"
        } else {
            myLabel.text = "The Switch is Off"
        }
    }
    @IBAction func mySliderChanged(_ sender: UISlider) {
        myLabel.text = String(Int(sender.value))
    }
    @IBAction func editingDidEnd(_ sender: UITextField) {
        myLabel.text = sender.text
        sender.resignFirstResponder()
    }
    
}

