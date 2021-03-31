//
//  ContactListTableViewController.swift
//  contacts
//
//  Created by Ryan Bitner on 3/29/21.
//

import UIKit

class ContactListTableViewController: UITableViewController {
    
    var allContacts = [Contact]()
    var friendsContacts: [Contact] {
        allContacts.filter({
            $0.isFriend
        })
    }
    
    var notFriendContacts: [Contact] {
        allContacts.filter({!$0.isFriend}
        )
    }
    
    func contactIndex(indexPath: IndexPath) -> Contact {
        if indexPath.section == 0 {
             return friendsContacts[indexPath.row]
        } else {
            return notFriendContacts[indexPath.row]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("Contacts").appendingPathExtension("plist")
        
        let propertyDecoder = PropertyListDecoder()
        
        if let retreivedContacts = try? Data(contentsOf: archiveURL), let decodedContacts = try? propertyDecoder.decode(Array<Contact>.self, from: retreivedContacts) {
            allContacts = decodedContacts
            
        
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("Contacts").appendingPathExtension("plist")
        
        let propertyListEncoder = PropertyListEncoder()
        
        let encodedContacts = try? propertyListEncoder.encode(allContacts)
        try? encodedContacts?.write(to: archiveURL, options: .noFileProtection)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return friendsContacts.count
        } else {
            return notFriendContacts.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Friends"
        } else {
            return "Not Friends"
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactCell
        let contact: Contact
        contact = contactIndex(indexPath: indexPath)
        cell.contact = contact
        cell.updateCell()
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contact = contactIndex(indexPath: indexPath)
            if let index = allContacts.firstIndex(of: contact) {
                allContacts.remove(at: index)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    //MARK: Actions
   @IBAction func unwindFromContactDetail(unwindSegue: UIStoryboardSegue) {
        guard let contactDetailTableViewController = unwindSegue.source as? ContactDetailTableViewController, let contact = contactDetailTableViewController.contact else {return}
        
        if let indexOfExistingContact = allContacts.firstIndex(of: contact) {
            allContacts[indexOfExistingContact] = contact
            tableView.reloadData()
        } else {
            let newIndexPath = IndexPath(row: allContacts.count, section: 0)
            allContacts.append(contact)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    @IBSegueAction func editContact(_ coder: NSCoder, sender: Any?) -> ContactDetailTableViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {return nil}
        tableView.deselectRow(at: indexPath, animated: true)
        
        let contactDetailTableViewController = ContactDetailTableViewController(coder: coder)
        contactDetailTableViewController?.contact = allContacts[indexPath.row]
        return contactDetailTableViewController
    }
    

}

extension ContactListTableViewController: ContactCellDelegate {
    func switchChanged(_ sender: ContactCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var contact = contactIndex(indexPath: indexPath)
            contact.isFriend.toggle()
            if let index = allContacts.firstIndex(of: contact) {
                allContacts[index] = contact
                tableView.reloadData()
                //tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    
}
