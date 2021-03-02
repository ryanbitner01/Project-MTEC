//
//  Game.swift
//  Apple Pie
//
//  Created by Ryan Bitner on 2/1/21.
//

import Foundation

struct Game {
    var word: String
    var guessedLetters: [Character] = []
    var incorrectMovesRemaining: Int
    
    mutating func playerGuessed(letter: Character) {
        guessedLetters.append(letter)
        if !word.contains(letter) {
            incorrectMovesRemaining -= 1
        }
    }
    
    var formattedWord: String {
        var guessedWord = ""
        for letter in word {
            if guessedLetters.contains(letter) {
                guessedWord += "\(letter)"
            } else {
                guessedWord += "_"
            }
        }
        return guessedWord
    }
}
