//
//  CategoryTableViewController.swift
//  OrderApp
//
//  Created by Ryan Bitner on 4/19/21.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    var categories = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        MenuController.shared.fetchCategories { (result) in
            switch result {
            case .success(let categories):
                self.updateUI(with: categories)
            case .failure(let error):
                self.displayError(error, title: "Failed to Fetch Categories")
            }
        }
    }
    
    func updateUI(with categories: [String]) {
        DispatchQueue.main.async {
            self.categories = categories
            self.tableView.reloadData()
        }
    }
    
    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)
        configureCell(cell, forCategoryAt: indexPath)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, forCategoryAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.capitalized
    }

    @IBSegueAction func showMenu(_ coder: NSCoder, sender: Any?) -> MenuTableViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {return nil}
        
        let category = categories[indexPath.row]
        return MenuTableViewController(coder: coder, category: category)
    }
}
