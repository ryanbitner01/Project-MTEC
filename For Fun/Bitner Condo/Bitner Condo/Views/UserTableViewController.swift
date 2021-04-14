//
//  UserTableViewController.swift
//  Bitner Condo
//
//  Created by Ryan Bitner on 4/14/21.
//

import UIKit

class UserTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return User.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        let user = User.users[indexPath.row]
        cell.textLabel?.text = user.familyName
        switch user.isAdmin {
        case true:
            cell.detailTextLabel?.text = "Admin"
        default:
            cell.detailTextLabel?.text = "User"
        }
        return cell
    }

    @IBSegueAction func editUser(_ coder: NSCoder, sender: Any?) -> EditUserTableViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {return nil}
        tableView.deselectRow(at: indexPath, animated: true)
        
        let editUserTableViewController = EditUserTableViewController(coder: coder)
        editUserTableViewController?.user = User.users[indexPath.row]
        return editUserTableViewController
    }
    
    @IBAction func unwindFromEditUser(_ unwindSegue: UIStoryboardSegue) {
        guard let sourceViewController = unwindSegue.source as? EditUserTableViewController, let user = sourceViewController.user, let indexOfUser = User.users.firstIndex(of: user) else {return}
        User.users[indexOfUser] = user
        tableView.reloadData()
        
    }
}
