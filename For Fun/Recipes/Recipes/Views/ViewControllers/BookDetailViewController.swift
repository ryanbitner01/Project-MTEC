//
//  BookDetailViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/1/21.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    var recipes: [Recipe] = []
    var book: Book?
    
    @IBOutlet weak var recipeCollectionView: UICollectionView!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeCollectionView.dataSource = self
        if let book = book {
            bookNameLabel.text = book.name
            setupBookImage()
        }
        // Do any additional setup after loading the view.
    }
    
    @IBSegueAction func editBook(_ coder: NSCoder) -> NewBookViewController? {
        let newBookVC = NewBookViewController(coder: coder)
        guard let book = self.book else {return nil}
        newBookVC?.book = book
        return newBookVC
    }
    
    func setupBookImage() {
        if let image = book?.image {
            imageView.image = UIImage(data: image)
            imageView.layer.cornerRadius = 25
        } else {
            guard let imageUrl = book?.imageURL, imageUrl != " " else {
                imageView.image = UIImage(systemName: "book.closed.fill")
                if let book = book {
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension BookDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        cell.recipe = recipes[indexPath.row]
        return cell
        
    }
}
