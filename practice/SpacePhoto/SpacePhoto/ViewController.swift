//
//  ViewController.swift
//  SpacePhoto
//
//  Created by Ryan Bitner on 4/15/21.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    
    // MARK: Properties
    
    let photoInfoController = PhotoInfoController()
    
    //MARK: View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAPOD()
    }
    
    func loadAPOD() {
        
        resetLabels()
        
        photoInfoController.fetchPhotoInfo { (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let photoInfo):
                    // update UI
                    self.updateUI(photoInfo: photoInfo)
                    
                case .failure(let error):
                    // update with error
                    self.updateUIError(error: error)
                }
            }
        }
    }
    
    func resetLabels() {
        title = ""
        imageView.image = UIImage(systemName: "photo.on.rectangle")
        descriptionLabel.text = ""
        copyrightLabel.text = ""
    }
    
    func updateUI(photoInfo: PhotoInfo) {
        self.title = photoInfo.title
        self.descriptionLabel.text = photoInfo.description
        self.copyrightLabel.text = photoInfo.copyright
        self.loadImageData(url: photoInfo.url)
    }
    
    func updateUIError(error: Error) {
        self.title = "Error Fetching Photo"
        self.imageView.image = UIImage(systemName: "exclamationmark.octagon")
        self.descriptionLabel.text = error.localizedDescription
        self.copyrightLabel.text = ""
    }
    
    func loadImageData(url: URL) {
        self.photoInfoController.fetchPhotoData(url: url) { (result) in
            
            DispatchQueue.main.async {
                switch result {
                case let .success(image):
                    self.imageView.image = image
                case .failure:
                    self.imageView.image = UIImage(systemName: "exclamationmark.octagon")
                }
            }
        }
    }


}

