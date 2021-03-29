//
//  ContactListTableViewController.swift
//  contacts
//
//  Created by Ryan Bitner on 3/29/21.
//

import UIKit

class ContactListTableViewController: UITableViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    var contacts = [Contact]()
    let defaultContactList: [Contact] = [
        Contact(name: "Ryan Bitner" , number: "8018224576", email: nil, isFriend: true)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        contacts.append(contentsOf: defaultContactList)
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("Contacts").appendingPathExtension("plist")
        
        let propertyDecoder = PropertyListDecoder()
        
        if let retreivedContacts = try? Data(contentsOf: archiveURL), let decodedContacts = try? propertyDecoder.decode(Array<Contact>.self, from: retreivedContacts) {
            contacts = decodedContacts
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
        
        let encodedContacts = try? propertyListEncoder.encode(contacts)
        try? encodedContacts?.write(to: archiveURL, options: .noFileProtection)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        let contact = contacts[indexPath.row]
        let name = contact.name
        
        cell.textLabel?.text = name
        
        return cell
    }
    
    //MARK: Actions
   @IBAction func unwindFromContactDetail(unwindSegue: UIStoryboardSegue) {
    guard let contactDetailTableViewController = unwindSegue.source as? ContactDetailTableViewController, let contact = contactDetailTableViewController.contact else {return}
    
    contacts.append(contact)
    
    tableView.reloadData()
    }

}
