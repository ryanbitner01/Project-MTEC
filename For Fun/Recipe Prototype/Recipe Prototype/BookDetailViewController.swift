//
//  BookDetailViewController.swift
//  Recipe Prototype
//
//  Created by Ryan Bitner on 5/19/21.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    var names: [String] = ["Chicken Alfredo", "Breakfast Burrito", "Spaghetti", "Ribs", "Moma's Mac & Cheese"]
    let colors: [String] = ["Lavender", "Green", "Red", "Orange", "Blue"]

    @IBOutlet weak var recipeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func getRandomColor(array: [String]) -> UIColor {
        let randomIndex = Int.random(in: 0...array.count - 1)
        guard let randomColor = UIColor(named: array[randomIndex]) else {return .black}
        return randomColor
    }
    
    @IBSegueAction func editBook(_ coder: NSCoder) -> CreateBookViewController? {
        let createBookViewController = CreateBookViewController(coder: coder)
        createBookViewController?.book = Book(name: "Grandma's Kitchen")
        return createBookViewController
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
        names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        cell.imageView.tintColor = getRandomColor(array: colors)
        cell.nameLabel.text = names[indexPath.row]
        cell.nameLabel.layer.borderColor = UIColor(named: "tintColor")?.cgColor
        cell.nameLabel.layer.borderWidth = 2
        cell.nameLabel.layer.cornerRadius = 10
        return cell
        
    }
    
    
}
