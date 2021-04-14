//
//  Reservation.swift
//  Bitner Condo
//
//  Created by Ryan Bitner on 4/14/21.
//

import Foundation

struct Reservation: Codable {
    var shareHolderName: String
    var guestName: String
    var phoneNumber: String
    var email: String
    var startDate: Date
    var endDate: Date
    var familyWeek: Bool
    var notes: String?
    var submittedBy: String
    var approved: Bool
}
