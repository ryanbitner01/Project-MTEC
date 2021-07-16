//
//  BookShareCell.swift
//  Recipes
//
//  Created by Ryan Bitner on 7/16/21.
//

import UIKit

class BookShareCell: UICollectionViewCell {
    
    var bookShareRequest: BookShareRequest?
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func updateCell() {
        label.text = bookShareRequest?.name
        setupImageView()
        //print(book?.bookColor)
    }
    
    func setupImageView() {
        if let image = bookShareRequest?.imageURL {
            guard let imageURL = URL(string: image), let imageData = try? Data(contentsOf: imageURL) else {return}
            imageView.image = UIImage(data: imageData)
            imageView.layer.cornerRadius = 25
        } else {
            guard let imageUrl = bookShareRequest?.imageURL, imageUrl != "" else {
                label.text = bookShareRequest?.name
                imageView.image = UIImage(systemName: "book.closed.fill")
                if let book = bookShareRequest {
                    let color = UIColor(named: book.color)
                    imageView.tintColor = color
                    return
                } else {
                    imageView.tintColor = .black
                }
                return
            }
            //imageView.image = UIImage(systemName: "book.closed.fill")
            BookController.shared.getBookImage(url: imageUrl) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.imageView.image = image
                        self.imageView.layer.cornerRadius = 25
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        }
    }
    
}


