//
//  JournalTableViewController.swift
//  journal-test
//
//  Created by Ryan Bitner on 4/28/21.
//

import UIKit

class JournalTableViewController: UITableViewController {
    
    var entries = [Journal]()
    let dataController = DataController()
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataController.fetchJournalEntries { (result) in
            switch result {
            case .success(let entries):
                DispatchQueue.main.async {
                    self.entries = entries
                    self.tableView.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
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
        cell.textLabel?.text = entry.date

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedEntry = entries.remove(at: indexPath.row)
            tableView.reloadData()
            dataController.deleteEntry(deletedEntry.uuid.uuidString)
        }
    }
    
    @IBAction func unwindToJournalTableView(_ unwindSegue: UIStoryboardSegue) {
        guard let sourceViewController = unwindSegue.source as? JournalEntryTableViewController, let journal = sourceViewController.journalEntry else {return}
        
        if let existingJournalEntry = entries.firstIndex(of: journal) {
            entries[existingJournalEntry] = journal
            tableView.reloadData()
            dataController.addEntry(journal)
        } else {
            entries.append(journal)
            tableView.reloadData()
            dataController.addEntry(journal)
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

