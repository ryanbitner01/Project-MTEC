//
//  JournalEntryTableViewController.swift
//  journal-test
//
//  Created by Ryan Bitner on 4/28/21.
//

import UIKit

class JournalEntryTableViewController: UITableViewController {
    
    var journalEntry: Journal?
    var date: Date?
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var entryTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let journalEntry = journalEntry {
            
            dateLabel.text = journalEntry.date
        } else {
            date = Date()
            dateLabel.text = dateFormatter.string(from: date!)
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let entryTextView = entryTextView.text, let date = dateLabel.text else {return}
        
        journalEntry = Journal(entry: entryTextView, date: date)
    }
    
}
