//
//  DataController.swift
//  journal-test
//
//  Created by Ryan Bitner on 4/28/21.
//

import Foundation

struct DataController {
    let collection = AppDelegate.db.collection("Journal")
    
    func fetchJournalEntries(completion: @escaping (Result<[Journal], Error>) -> Void){
        collection.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let qs = querySnapshot {
                let entries = qs.documents.compactMap { doc -> Journal? in
                    let data = doc.data()
                    guard let date = data["Date"] as? String, let entry = data["Entry"] as? String, let uuidFromString = UUID(uuidString: doc.documentID) else {return nil}
                    var journal = Journal(entry: entry, date: date)
                    journal.uuid = uuidFromString
                    return journal
                }
                completion(.success(entries))
            }
        }
    }
    
    func addEntry(_ journal: Journal) {
        collection.document(journal.uuid.uuidString).setData([
            "Date": journal.date,
            "Entry": journal.entry
        ])
    }
    
    func deleteEntry(_ docName: String) {
        collection.document(docName).delete()
    }
}
