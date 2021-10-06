//
//  Network.swift
//  TestingArchitecture
//
//  Created by Ryan Bitner on 9/16/21.
//

import Foundation

struct Network: QuoteGenerator {
    
    let baseUrl = URL(string: "https://api.tronalddump.io/")
    var randomURL: URL {
        return URL(string: "random/quote", relativeTo: baseUrl)!
    }
    
    func getRandomQuote(completion: @escaping (Result<Quote, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: randomURL) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                let quote = try decoder.decode(Quote.self, from: data)
                    completion(.success(quote))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
