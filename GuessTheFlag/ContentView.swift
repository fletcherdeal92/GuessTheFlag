//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Fletcher Deal on 7/10/22.
//

//TODO: Tell players when they have the wrong flag
//TODO: Make game last only 8 rounds with a final score and restart

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var score = 0
    @State private var scoreMessage = ""
    
    @State private var roundCheck = 1
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }

                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            if roundCheck <= 8 {
                Button("Continue", action: askQuestion)
            } else {
                Button("Restart", action: restartGame)
            }
            
        } message: {
            Text("Your score is \(score) of 8 in round \(roundCheck - 1) \n \(scoreMessage)")
        }
        
    }
    
    func flagTapped(_ number: Int) {
        if roundCheck <= 8 {
            if number == correctAnswer {
                scoreTitle = "Correct"
                scoreMessage = "Congratulations you picked the correct flag"
                score += 1
                roundCheck += 1
            } else {
                scoreTitle = "Wrong"
                scoreMessage = "You picked the flag for \(countries[number])"
                
                roundCheck += 1
                
                if score > 0 {
                    score -= 1
                }
            }
        } else {
            scoreTitle = "Game Over"
            if score == roundCheck {
                scoreMessage = "Congratulations you got all the questions correct"
            } else {
                scoreMessage = "You got \(score) out of \(roundCheck) correct"
            }
        }
        
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func restartGame() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        score = 0
        roundCheck = 1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
