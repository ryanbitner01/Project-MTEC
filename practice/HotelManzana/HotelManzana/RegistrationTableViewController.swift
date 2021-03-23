//
//  RegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Ryan Bitner on 3/23/21.
//

import UIKit

class RegistrationTableViewController: UITableViewController {
    
    var registrations: [Registration] = []
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return dateFormatter
    }()

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
        return registrations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationCell", for: indexPath)
        let registration = registrations[indexPath.row]
        let name = registration.firstName + " " + registration.lastName
        let checkIn = dateFormatter.string(from: registration.checkInDate)
        let checkOut = dateFormatter.string(from: registration.checkOutDate)
        let description = "\(checkIn) - \(checkOut): \(registration.roomType.name)"
        // Configure the cell...
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = description

        return cell
    }
    
    @IBAction func unwindFromAddRegistration(undwindSegue: UIStoryboardSegue) {
        guard let addRegistrationTableViewController = undwindSegue.source as? AddRegistrationTableViewController, let registration = addRegistrationTableViewController.registration else {return}
        registrations.append(registration)
        tableView.reloadData()
    }

}
