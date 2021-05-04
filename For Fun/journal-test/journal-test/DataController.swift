//
//  DataController.swift
//  journal-test
//
//  Created by Ryan Bitner on 4/28/21.
//

import Foundation

struct DataController {
    let collection = AppDelegate.db.collection("Journal")
    let users = AppDelegate.db.collection("Users")
    
    func fetchJournalEntries(_ uuid: String, completion: @escaping (Result<[Journal], Error>) -> Void){
        users.document(uuid).collection("Journal").getDocuments { (querySnapshot, error) in
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
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        users.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let qs = querySnapshot {
                let users = qs.documents.compactMap { doc -> User? in
                    let data = doc.data()
                    guard let username = data["username"] as? String, let password = data["password"] as? String, let email = data["email"] as? String, let uuidFromString = UUID(uuidString: doc.documentID) else {return nil}
                    var user = User(user: username, password: password, email: email)
                    user.ID = uuidFromString
                    return user
                }
                completion(.success(users))
            }
        }
    }
    
    
    func addEntry(user: User, journal: Journal) {
        users.document(user.ID.uuidString).collection("Journal").document(journal.uuid.uuidString).setData([
            "Date": journal.date,
            "Entry": journal.entry
        ])
    }
    
    func deleteEntry(_ docName: String, uuid: String) {
        //collection.document(docName).delete()
        users.document(uuid).collection("Journal").document(docName).delete()
    }
    
    func addUser(_ user: User) {
        users.document(user.ID.uuidString).setData([
            "username": user.user,
            "password": user.password,
            "email": user.email
        ])
        users.document(user.ID.uuidString).collection("Journal")
    }
    
}
