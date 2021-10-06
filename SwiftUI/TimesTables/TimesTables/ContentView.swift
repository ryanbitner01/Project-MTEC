//
//  ContentView.swift
//  TimesTables
//
//  Created by Ryan Bitner on 7/28/21.
//

import SwiftUI

struct Controls: View {
    @Binding var practiceNumber: Double
    @Binding var numberOfRounds: Int
    var body: some View {
        VStack {
            Stepper("Practice my times by \(practiceNumber, specifier: "%.0f")'s", value: $practiceNumber, in: 0...12)
                .padding(15)
            Stepper("Number of Questions \(numberOfRounds)", value: $numberOfRounds, in: 0...25)
        }
    }
}

struct Game: View {
    
    @Binding var isShowingControls: Bool
    @State var isShowingEndOfGame = false
    @State var animationAmount = true
    @State var practiceNumber: Double
    @State var answer = ""
    @State var score = 0
    @State var isCorrect = true
    @Binding var round: Int
    @State var numberOfRounds: Int

    @State private var mulipliedBy = Int.random(in: 0...12)
    
    var correctAnswer: Double {
        let multipliedBy = Double(mulipliedBy)
        return multipliedBy * practiceNumber
    }
    
    var userAnswer: Double {
        return Double(answer) ?? 0
    }
    
    var body: some View {
        VStack(spacing: 25) {
            Text("\(practiceNumber, specifier: "%.0f") X \(mulipliedBy)")
                .font(.largeTitle)
                .background(isCorrect ? Color.clear: Color.red)
                .opacity(animationAmount ? 1 : 0)
            TextField("Answer", text: $answer)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
            Button("Submit") {
                withAnimation(.spring()) {
                    animationAmount.toggle()
                    scoreAnswer()
                }
            }
            .frame(width: 100, height: 30)
            .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.3, green: 0.7, blue: 1), Color(red: 0.1, green: 0.8, blue: 1)]), startPoint: .leading, endPoint: .trailing))
            .foregroundColor(.white)
            .clipShape(Capsule())
            
            Text("Score: \(score)")
            Text("Question \(round)/\(numberOfRounds)")
        }
        .padding()
        .alert(isPresented: $isShowingEndOfGame, content: {
            Alert(title: Text("End of Game"),
                  message: Text("Your score was \(score), great job!"),
                  dismissButton: .default(Text("Restart"), action: newGame))
        })
    }
    
    func newGame() {
        score = 0
        round = 0
        numberOfRounds = 0
        isShowingControls = true
    }
    
    func scoreAnswer() {
        if correctAnswer == userAnswer {
            self.score += 1
        } else {
            withAnimation(
                Animation.easeOut(duration: 2.0)
            ) {
                isCorrect = false
            }
        }
        newRound()
    }
    
    func newRound() {
        round += 1
        if round > numberOfRounds {
            isShowingEndOfGame = true
            return
        }
        withAnimation(.spring()) {
            animationAmount.toggle()
            mulipliedBy = Int.random(in: 0...12)
            isCorrect = true
            answer = ""
        }
        
    }
}

struct ContentView: View {
    @State private var practiceNumber = 0.0
    @State private var isShowingControls = true
    @State private var numberOfRounds = 0
    @State private var round = 1
    
    var multipliedBy: [Double] {
        var empty: [Double] = []
        for num in 0...12 {
            empty.append(Double(num))
        }
        return empty
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            if isShowingControls {
                Controls(practiceNumber: $practiceNumber, numberOfRounds: $numberOfRounds)
            } else {
                Game(isShowingControls: $isShowingControls, practiceNumber: practiceNumber, round: $round, numberOfRounds: numberOfRounds)
            }
            
            Spacer()
            
            Button(isShowingControls ? "Play": "Restart") {
                isShowingControls.toggle()
            }
            .frame(width: 100, height: 30)
            .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.1, green: 0.9, blue: 0.2), Color(red: 0.1, green: 0.8, blue: 0)]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .foregroundColor(.white)
            .clipShape(Capsule())
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
