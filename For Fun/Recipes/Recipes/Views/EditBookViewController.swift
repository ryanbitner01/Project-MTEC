//
//  EditBookViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/11/21.
//

import UIKit

class EditBookViewController: UIViewController {
    
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var selectColorButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var book: Book?
    
    var image: UIImage?
    
    let colors: [UIColor] = [.black, .blue, .systemPink, .systemOrange, .red]
    
    override func viewDidLoad() {
        //BookController.shared.delegate = self
        super.viewDidLoad()
        
        colorsCollectionView.dataSource = self
        colorsCollectionView.delegate = self
        setupImageView()
        nameTextField.text = book?.name
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func colorPickerButtonSelected(_ sender: UIButton) {
        selectColorButton.isSelected.toggle()
        print(selectColorButton.isSelected)
        updateUI()
    }
    
    @IBAction func savePressed(_ sender: Any) {
        guard let book = book, let user = UserControllerAuth.shared.user else {return}
        let newBook = Book(name: nameTextField.text!, id: book.id, image: image?.jpegData(compressionQuality: 0.9), bookColor: getColorString(color: bookImageView.tintColor))
        
        if image != nil {
            //Delete Old Image if there is one
            BookController.shared.deleteBookImage(book: book)
            // Add new image
            BookController.shared.addBookImage(user, book: newBook, new: false)
        } else {
            // else save color for system image
            BookController.shared.updateBook(book: newBook)
        }
        self.book = newBook
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let book = book else {return}
        let newBook = Book(name: nameTextField.text!, id: book.id, image: image?.jpegData(compressionQuality: 0.9), bookColor: getColorString(color: bookImageView.tintColor))
        self.book = newBook
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
    
    func setupImageView() {
        if let imageData = book?.image {
            self.bookImageView.image = UIImage(data: imageData)
            self.bookImageView.layer.cornerRadius = 25
        } else {
            guard let imageUrl = book?.imageURL, imageUrl != " " else {
                bookImageView.image = UIImage(systemName: "book.closed.fill")
                if let book = book {
                    let color = BookController.shared.getBookColor(book: book)
                    bookImageView.tintColor = color
                    return
                } else {
                    bookImageView.tintColor = .black
                }
                return
            }
            
            BookController.shared.getBookImage(url: imageUrl) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.bookImageView.image = image
                        self.bookImageView.layer.cornerRadius = 25
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        }
        updateUI()
    }
    
    func updateColorButton() {
        selectColorButton.tintColor = bookImageView.tintColor
    }
    
    func updateColorPicker() {
        colorsCollectionView.isHidden = !selectColorButton.isSelected
        //print(colorsCollectionView.isHidden)
    }
    
    func getColorString(color: UIColor) -> String {
        switch color {
        case .black:
            return "black"
        case .blue:
            return "blue"
        case .systemPink:
            return "pink"
        case .systemOrange:
            return "orange"
        case .red:
            return "red"
        default:
            return "black"
        }
    }
    
}

extension EditBookViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
        cell.color = colors[indexPath.row]
        cell.updateCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCell else {return}
        bookImageView.tintColor = cell.color
        bookImageView.image = UIImage(systemName: "book.closed.fill")
        image = nil
        updateUI()
    }
    
    
}

extension EditBookViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {return}
        
        bookImageView.image = selectedImage
        bookImageView.layer.cornerRadius = 25
        image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
}
//
//extension EditBookViewController: BookControllerDelegate {
//    func booksUpdated() {
//        setupImageView()
//    }
