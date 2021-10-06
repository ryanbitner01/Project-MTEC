//
//  MockNetwork.swift
//  TestingArchitecture
//
//  Created by Ryan Bitner on 9/16/21.
//

import Foundation

protocol QuoteGenerator {
    func getRandomQuote(completion: @escaping (Result<Quote, Error>) -> Void)
}

struct MockNetwork: QuoteGenerator {
    
    var fakeRandomJSON = """
        {
            "created_at": "2019-12-13T17:02:34.658Z",
            "quote_id": "Test0",
            "tags": [
                "Test",
                "Test2"
            ],
            "value": "Trump Said this",
        }
        """
    
    func getRandomQuote(completion: @escaping (Result<Quote, Error>) -> Void) {
        let decoder = JSONDecoder()
        do {
            let quote = try decoder.decode(Quote.self, from: fakeRandomJSON.data(using: .utf8)!)
            completion(.success(quote))
        } catch {
            completion(.failure(error))
        }
    }
}
