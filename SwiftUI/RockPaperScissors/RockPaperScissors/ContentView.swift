//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Ryan Bitner on 7/26/21.
//

import SwiftUI

struct ContentView: View {
    let moves = ["Rock", "Paper", "Scissors"]
    @State private var appChoice = Int.random(in: 0...2)
    @State private var shouldWin = Bool.random()
    @State private var score = 0
    @State private var userChoice = 0
    
    let rockWin = 1
    let paperWin = 2
    let scissorsWin = 0
    let rockLose = 2
    let paperLose = 0
    let scissorsLose = 1
    
    @State private var round = 0
    @State private var isShowingEndScreen = false
    
    var body: some View {
        VStack(alignment: .center ,spacing: 20) {
            Section {
                Text("Score: \(score)")
                Text("Computer Move: \(moves[appChoice])")
                Text("\(shouldWin ? "Select the winning move": "Select the losing move")")
            }
            Section {
                HStack (spacing: 40) {
                    Button(action: {
                        userChoice = 0
                        self.adjustScore()
                        self.newRound()
                    }) {
                        Text("Rock")
                    }
                    
                    Button(action: {
                        userChoice = 1
                        self.adjustScore()
                        self.newRound()
                    }) {
                        Text("Paper")
                    }
                    
                    Button(action: {
                        userChoice = 2
                        self.adjustScore()
                        self.newRound()
                    }) {
                        Text("Scissors")
                    }
                }
            }
        }
        .alert(isPresented: $isShowingEndScreen, content: {
            Alert(title: Text("End of Game"),
                  message: Text("Score: \(score)"),
                  dismissButton: .default(Text("Restart")) {
                    self.newGame()
                  })
        })
    }
    func newGame() {
        score = 0
        round = 0
        self.newRound()
    }
    
    func newRound() {
        round += 1
        // Check that round is no greater than 10
        if round <= 10 {
            appChoice = Int.random(in: 0...2)
            shouldWin = Bool.random()
        } else {
            isShowingEndScreen = true
        }
    }
    
    func adjustScore() {
        //Rock Win
        if appChoice == 0 && shouldWin {
            if userChoice == rockWin {
                score += 1
            } else {
                score -= 1
            }
        //Rock Lose
        } else if appChoice == 0 && !shouldWin {
            if userChoice == rockLose {
                score += 1
            } else {
                score -= 1
            }
        // Paper Win
        } else if appChoice == 1 && shouldWin {
            if userChoice == paperWin {
                score += 1
            } else {
                score -= 1
            }
        // Paper Lose
        } else if appChoice == 1 && !shouldWin {
            if userChoice == paperLose {
                score += 1
            } else {
                score -= 1
            }
        // Scissors Win
        } else if appChoice == 2 && shouldWin {
            if userChoice == scissorsWin {
                score += 1
            } else {
                score -= 1
            }
        // Scissors Lose
        } else if appChoice == 2 && !shouldWin {
            if userChoice == scissorsLose {
                score += 1
            } else {
                score -= 1
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
