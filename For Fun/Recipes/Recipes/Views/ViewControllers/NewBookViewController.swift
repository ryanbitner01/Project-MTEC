//
//  NewBookViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/10/21.
//

import UIKit

class NewBookViewController: UIViewController {
    
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var selectColorButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var image: UIImage?
    var colorName: String?
    var book: Book?
    //let colors: [UIColor] = [.black, .blue, .systemPink, .systemOrange, .red]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        colorsCollectionView.dataSource = self
        colorsCollectionView.delegate = self
        bookImageView.layer.cornerRadius = 25
        setupImageView()
        if let book = book {
            nameTextField.text = book.name
            bookImageView.tintColor = UIColor(named: book.bookColor)
            updateColorButton()
        }
        // Do any additional setup after loading the view.
    }
    
    func setupImageView() {
        bookImageView.layer.cornerRadius = 25
        //guard let book = book else {return}
        if let imageURL = book?.imageURL, imageURL != "" {
            RecipeController.shared.getRecipeImage(url: imageURL) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.bookImageView.image = image
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        } else if let image = book?.image {
            bookImageView.image = UIImage(data: image)
        }
    }
    
    @IBAction func colorPickerButtonSelected(_ sender: UIButton) {
        selectColorButton.isSelected.toggle()
        //print(selectColorButton.isSelected)
        updateUI()
    }
    
    @IBAction func savePressed(_ sender: Any) {
        guard let user = UserControllerAuth.shared.user else {return}
        if let image = image, let imageData: Data = image.jpegData(compressionQuality: 0.9) {
            var book = Book(name: nameTextField.text ?? "", id: self.book?.id ?? UUID(), image: imageData)
            BookController.shared.addBookImage(user, book: book, new: true)
            book.image = imageData
            self.book = book
            performSegue(withIdentifier: "SaveBook", sender: self)
        } else {
            let book = Book(name: nameTextField.text ?? "", id: self.book?.id ?? UUID(), bookColor: colorName ?? "")
            BookController.shared.addBook(user, book: book)
            self.book = book
            performSegue(withIdentifier: "SaveBook", sender: self)
        }
        
        
    }
    
    @IBAction func textEdited(_ sender: UITextField) {
        updateUI()
    }
    
    @IBAction func textEditDone(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func photoButtonTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Image Source", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let libraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(libraryAction)
        }
        
        alertController.popoverPresentationController?.sourceView = self.view
        
        present(alertController, animated: true, completion: nil)
    }
    //MARK: Methods
    
    func updateUI() {
        updateColorButton()
        updateColorPicker()
    }
    
    func updateColorButton() {
        selectColorButton.tintColor = bookImageView.tintColor
    }
    
    func updateColorPicker() {
        colorsCollectionView.isHidden = !selectColorButton.isSelected
        //print(colorsCollectionView.isHidden)
    }
    
//    func getColorString(color: UIColor) -> String {
//        switch color {
//        case .black:
//            return "black"
//        case .blue:
//            return "blue"
//        case .systemPink:
//            return "pink"
//        case .systemOrange:
//            return "orange"
//        case .red:
//            return "red"
//        default:
//            return "black"
//        }
//    }
    
}

extension NewBookViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        BookController.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
        let color = UIColor(named: BookController.colors[indexPath.row])
        cell.color = color
        cell.colorName = BookController.colors[indexPath.row]
        cell.updateCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCell else {return}
        bookImageView.tintColor = cell.color
        bookImageView.image = UIImage(systemName: "book.closed.fill")
        colorName = cell.colorName
        image = nil
        updateUI()
    }
    
    
}

extension NewBookViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {return}
        
        bookImageView.image = selectedImage
        bookImageView.layer.cornerRadius = 25
        image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
}
