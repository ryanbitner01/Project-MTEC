//
//  MenuTableViewController.swift
//  OrderApp
//
//  Created by Ryan Bitner on 4/19/21.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        
        return formatter
    }()
    
    let category: String
    let menuController = MenuController()
    var menuItems = [MenuItem]()
    
    init? (coder: NSCoder, category: String) {
        self.category = category
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = category

        MenuController.shared.fetchMenuItems(forCategory: category) { (result) in
            switch result {
            case .success(let menuItems):
                self.updateUI(with: menuItems)
            case .failure(let error):
                self.displayError(error, title: "Failed to Fetch Menu Items for \(self.category)")
            }
        }
    }
    
    func updateUI(with menuItems: [MenuItem]) {
        DispatchQueue.main.async {
            self.menuItems = menuItems
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
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem", for: indexPath)
        configure(cell, forItemAt: indexPath)
        return cell
    }
    
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let menuItem = menuItems[indexPath.row]
        cell.textLabel?.text = menuItem.name
        cell.detailTextLabel?.text = priceFormatter.string(from: NSNumber(value: menuItem.price))
    }
   
    @IBSegueAction func showMenuItem(_ coder: NSCoder, sender: Any?) -> MenuDetailViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {return nil}
        let menuItem = menuItems[indexPath.row]
        return MenuDetailViewController(coder: coder, menuItem: menuItem)
    }
}
