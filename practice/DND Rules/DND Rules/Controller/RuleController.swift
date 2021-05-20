//
//  RuleController.swift
//  DND Rules
//
//  Created by Ryan Bitner on 5/11/21.
//

import Foundation

enum RuleControllerError: Error {
    case unknown
    case failedtToParse
    
}

struct RulesResult: Codable {
    let results: [Rule]
}

struct SubResult: Codable {
    let subsections: [Rule]
}

extension RuleControllerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "An Unkown error has occured."
        case .failedtToParse:
            return "Failed to parse"
        }
    }
}

class RuleController {
    static let shared = RuleController()
    
    private init() {
        
    }
    
    func fetchRules(completion: @escaping (Result<[Rule], RuleControllerError>) -> Void) {
        let session = URLSession.shared
        
        let request = URLRequest(url: URL(string: "https://www.dnd5eapi.co/api/rules")!)
        
        let task = session.dataTask(with: request) {(data, response, error) in
            if let data = data, (response as? HTTPURLResponse)?.statusCode == 200 {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(RulesResult.self, from: data)
                    completion(.success(result.results))
                } catch let error {
                    print(error)
                    completion(.failure(.failedtToParse))
                }
            } else {
                completion(.failure(.unknown))
            }
        }
        task.resume()
    }
    
    func fetchRule(rule: String ,completion: @escaping (Result<[Rule], RuleControllerError>) -> Void) {
        let session = URLSession.shared
        
        var baseURL = "https://www.dnd5eapi.co/api/rules"
        
        baseURL += "/" + rule
        
        let request = URLRequest(url: URL(string: baseURL)!)
        
        let task = session.dataTask(with: request) {(data, response, error) in
            if let data = data, (response as? HTTPURLResponse)?.statusCode == 200 {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(SubResult.self, from: data)
                    completion(.success(result.subsections))
                } catch let error {
                    print(error)
                    completion(.failure(.failedtToParse))
                }
            } else {
                completion(.failure(.unknown))
            }
        }
        task.resume()
    }
}
