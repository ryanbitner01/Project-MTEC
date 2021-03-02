//
//  ViewController.swift
//  GetToKnowMe
//
//  Created by Ryan Bitner on 1/14/21.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Connections
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var hobbyButton: UIButton!
    @IBOutlet weak var familyButton: UIButton!
    
    //MARK: Variables
    let infoString = "Welcome to my life. I am 19 years old. I started university, but haven't finished yet. I work for a small ISP called Veracity Networks. I have 5 dogs between 2 houses. I live in Orem"
    let hobbyString = "I have several hobbies the main hobby of mine is gaming and more specifically league of legends. I am a qiyanna main. I have been playing since I was 12. I also paint, play cello, and various other things."
    let familyString = "I have 2 families my parents are divorced, I have 4 siblings. I have 3 sisters and a brother. I am the second oldest. Both families live a couple blocks apart. We love dogs, I have 3 dogs at one house and 2 at the other."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: Actions
    @IBAction func infoButtonPressed(_ sender: Any) {
        textLabel.text = infoString
        image.image = UIImage(named: "MainImage")
        print("Info")
    }
    @IBAction func hobbyButtonPressed(_ sender: Any) {
        textLabel.text = hobbyString
        image.image = UIImage(named: "GamingImage")
        print("Hobby")
    }
    @IBAction func familyButtonPressed(_ sender: Any) {
        textLabel.text = familyString
        image.image = UIImage(named: "FamilyImage")
        print("Family")
    }
    

}

