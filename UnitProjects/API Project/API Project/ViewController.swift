//
//  ViewController.swift
//  API Project
//
//  Created by Ryan Bitner on 4/22/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dogImageView: UIImageView!
    let controller = APIController()
    var url = URL(string: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func randomImage() {
        controller.fetchRandomDogImageURL { (result) in
            switch result {
            case.success(let url):
                self.fetchImage(with: url)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchImage(with url: URL) {
        controller.fetchDogImage(with: url) { (result) in
            switch result {
            case.success(let image):
                DispatchQueue.main.async {
                    self.dogImageView.image = image
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func randomPushed(_ sender: Any) {
        randomImage()
    }
    


}

