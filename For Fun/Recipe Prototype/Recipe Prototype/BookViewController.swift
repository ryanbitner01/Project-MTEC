//
//  BookViewController.swift
//  Recipe Prototype
//
//  Created by Ryan Bitner on 5/18/21.
//

import UIKit

class BookViewController: UIViewController {

    @IBOutlet weak var bookCollectionView: UICollectionView!
    
    var names: [String] = ["Test", "Family Recipes", "Grandma's Kitchen", "BBQ", "Just Desserts"]
    
    var colors: [String] = ["Lavender", "Green", "Red", "Blue", "Orange"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func getRandomColor(array: [String]) -> UIColor {
        let randomIndex = Int.random(in: 0...array.count - 1)
        guard let randomColor = UIColor(named: array[randomIndex]) else {return .black}
        return randomColor
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

extension BookViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
        cell.imageView.tintColor = getRandomColor(array: colors)
        cell.nameLabel.text = names[indexPath.row]
        cell.imageView.layer.cornerRadius = 15
        cell.nameLabel.layer.borderColor = UIColor(named: "tintColor")?.cgColor
        cell.nameLabel.layer.borderWidth = 2
        cell.nameLabel.layer.cornerRadius = 10
        return cell
    }
    
    
}
