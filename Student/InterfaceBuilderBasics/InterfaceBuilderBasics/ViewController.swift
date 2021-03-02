//
//  ViewController.swift
//  InterfaceBuilderBasics
//
//  Created by Ryan Bitner on 1/14/21.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Connections
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonPress(_ sender: Any) {
        textLabel.text = "This app rocks!"
    }
    
}

