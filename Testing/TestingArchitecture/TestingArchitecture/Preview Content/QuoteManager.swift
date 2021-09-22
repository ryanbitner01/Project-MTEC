//
//  QuoteManager.swift
//  TestingArchitecture
//
//  Created by Ryan Bitner on 9/16/21.
//

import Foundation

class QuoteManager: ObservableObject {
    
    @Published var quote: Quote?
    
    let quoteGenerator: QuoteGenerator
    
    init(quoteGen: QuoteGenerator = Network()) {
        self.quoteGenerator = quoteGen
    }
    
    func getRandomQuote() {
        quoteGenerator.getRandomQuote { result in
            switch result {
            case .success(let quote):
                DispatchQueue.main.async {
                    self.quote = quote
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
