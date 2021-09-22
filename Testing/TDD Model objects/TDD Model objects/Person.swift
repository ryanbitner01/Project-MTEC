//
//  Person.swift
//  TDD Model objects
//
//  Created by Ryan Bitner on 9/13/21.
//

import Foundation

struct Person {
    var name: String
    var age: Int
    var height: Int?
    var weight: Int?
}

func evenNumbers(numbers: [Int]) -> [Int] {
    return numbers.filter({$0 % 2 == 0})
}
