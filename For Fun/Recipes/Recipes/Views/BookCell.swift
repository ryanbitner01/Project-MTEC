//
//  BookCell.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/8/21.
//

import UIKit

class BookCell: UICollectionViewCell {

    var book: Book?

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    func updateCell() {
        label.text = book?.name
        setupImageView()
        //print(book?.bookColor)
    }

    func setupImageView() {
        guard let imageUrl = book?.imageURL, imageUrl != " " else {
            label.text = book?.name
            imageView.image = UIImage(systemName: "book.closed.fill")
            if let book = book {
                let color = BookController.shared.getBookColor(book: book)
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
