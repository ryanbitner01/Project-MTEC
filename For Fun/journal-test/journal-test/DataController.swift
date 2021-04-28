//
//  DataController.swift
//  journal-test
//
//  Created by Ryan Bitner on 4/28/21.
//

import Foundation

struct DataController {
    let collection = AppDelegate.db.collection("Journal")
    
    func fetchJournalEntries() {
        
    }
    
    func updateEntries(_ journal: [Journal]) {
        for entry in journal {
            collection.addDocument(data: ["Date": entry.date,
                                          "Entry": entry.entry
            ])
        }
    }
}
