//
//  TVShow.swift
//  TableView Practice
//
//  Created by Ryan Bitner on 3/11/21.
//

import Foundation

struct TVShow {
    static let dateFormatter = RelativeDateTimeFormatter()
    var watchedAt: Date
    var title: String
    var description: String
    
    var watchedAtString: String {
        if Calendar.current.isDateInToday(watchedAt) {
            return "Today"
        }
        if let realtiveString = TVShow.dateFormatter.string(for: watchedAt) {
            return realtiveString
        } else {
            return watchedAt.description
        }
    }
}


