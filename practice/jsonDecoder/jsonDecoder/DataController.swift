//
//  DataController.swift
//  jsonDecoder
//
//  Created by Ryan Bitner on 4/13/21.
//

import Foundation

struct Report: Codable {
    let name: String
    let creationDate: Date
    let profileID: String
    let readCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case name
        case creationDate = "report_date"
        case profileID = "profile_id"
        case readCount = "read_count"
    }
}


class DataController {
    let session = URLSession.shared
    
    func getObjects(completion: @escaping (Report?)-> Void) -> Void {
        let task = session.dataTask(with: <#T##URLRequest#>) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data {
                let report = try? jsonDecoder.decode(Report.self, from: data)
                print(report)
                completion(report)
            }
        }
        task.resume()
    }
}
