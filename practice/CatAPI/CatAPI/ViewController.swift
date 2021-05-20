//
//  ViewController.swift
//  CatAPI
//
//  Created by Ryan Bitner on 5/7/21.
//

import UIKit

class ViewController: UIViewController {
    
    let controller = CatController()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        randomCat()
    }

    @IBAction func didTapRefresh(_ sender: Any) {
        randomCat()
    }
    
    func randomCat() {
        controller.getCat { result in
            switch result {
            case .success(let cat):
                self.getCatImage(cat: cat)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getCatImage(cat: Cat) {
        controller.getCatImage(cat: cat) { result in
            switch result {
            case.success(let image):
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

