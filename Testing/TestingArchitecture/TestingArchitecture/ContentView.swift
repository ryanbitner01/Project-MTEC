//
//  ContentView.swift
//  TestingArchitecture
//
//  Created by Ryan Bitner on 9/16/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var manager: QuoteManager = QuoteManager()
    
    var body: some View {
        VStack {
            if let quote = manager.quote {
                Text(quote.value)
                Text(quote.createdAt)
                ForEach(quote.tags, id: \.self) { tag in
                    Text(tag)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.blue))
                }
            } else {
                Text("No Quote")
            }
            Button(action: getQuote, label: {
                Text("Random Quote")
            })
        }
    }
    
    func getQuote() {
        manager.getRandomQuote()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

