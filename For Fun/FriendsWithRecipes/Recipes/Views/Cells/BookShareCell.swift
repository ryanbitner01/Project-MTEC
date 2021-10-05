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
        label.text = bookShareRequest?.bookName
        setupImageView()
        //print(book?.bookColor)
    }
    
    func setupImageView() {
        guard let imageUrl = bookShareRequest?.bookImageURL, imageUrl != "" else {
            label.text = bookShareRequest?.bookName
            imageView.image = UIImage(systemName: "book.closed.fill")
            if let book = bookShareRequest {
                let color = UIColor(named: book.bookColor)
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


