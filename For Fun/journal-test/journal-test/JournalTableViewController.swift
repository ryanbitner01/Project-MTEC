//
//  JournalTableViewController.swift
//  journal-test
//
//  Created by Ryan Bitner on 4/28/21.
//

import UIKit

class JournalTableViewController: UITableViewController {
    
    var entries = [Journal]()
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
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
        return entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "journalEntryCell", for: indexPath)
        let entry = entries[indexPath.row]
        cell.textLabel?.text = dateFormatter.string(from: entry.date)

        return cell
    }
    
    @IBAction func unwindToJournalTableView(_ unwindSegue: UIStoryboardSegue) {
        guard let sourceViewController = unwindSegue.source as? JournalEntryTableViewController, let journal = sourceViewController.journalEntry else {return}
        
        if let existingJournalEntry = entries.firstIndex(of: journal) {
            entries[existingJournalEntry] = journal
            tableView.reloadData()
        } else {
            entries.append(journal)
            tableView.reloadData()
        }
        // Use data from the view controller which initiated the unwind segue
    }
    
    @IBSegueAction func editJournalEntry(_ coder: NSCoder, sender: Any?) -> JournalEntryTableViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {return nil}
        let journalEntryTableViewController = JournalEntryTableViewController(coder: coder)
        journalEntryTableViewController?.journalEntry = entries[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        return journalEntryTableViewController
    }
}

