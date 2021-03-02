//
//  ViewController.swift
//  Light
//
//  Created by Ryan Bitner on 1/15/21.
//

import UIKit

class ViewController: UIViewController {
    
    var lightOn = true

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    fileprivate func updateUI() {
        view.backgroundColor = lightOn ? .white : .black
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        lightOn.toggle()
        updateUI()
    }
    
}

