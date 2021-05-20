//
//  CreateBookViewController.swift
//  Recipe Prototype
//
//  Created by Ryan Bitner on 5/19/21.
//

import UIKit

class CreateBookViewController: UIViewController {
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var paintButton: UIButton!
    @IBOutlet weak var bookImageView: UIImageView!
    
    let colors: [String] = ["Lavender", "Green", "Red", "Orange", "Blue"]
    var book: Book?
    override func viewDidLoad() {
        super.viewDidLoad()
        colorsCollectionView.dataSource = self
        colorsCollectionView.delegate = self
        colorsCollectionView.isHidden = true
        updateColor()
        editBook()
        // Do any additional setup after loading the view.
    }
    
    func editBook() {
        if let book = book {
            nameTextField.text = book.name
        }
    }
    
    @IBAction func colorPressed(_ sender: Any) {
        colorsCollectionView.isHidden.toggle()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateColor() {
        bookImageView.tintColor = paintButton.tintColor
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

extension CreateBookViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
        cell.colorImage.tintColor = UIColor(named: colors[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ColorCell
        let color = cell.colorImage.tintColor
        paintButton.tintColor = color
        updateColor()
        
    }
    
    
}
