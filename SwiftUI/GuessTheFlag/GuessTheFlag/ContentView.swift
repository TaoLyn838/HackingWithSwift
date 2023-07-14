//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by CHENGTAO on 6/25/23.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
        
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var playerScore = 0
    @State private var QuestionNumberID = 1
    @State private var restartGame = false
    
    @ViewBuilder var FlagImage: some View {
        ForEach(0..<3, id: \.self) {number in
            Button {
                flagTapped(num: number)
            } label: {
                Image(countries[number])
                    .renderingMode(.original)
                    .clipShape(Capsule())
                    .shadow(color: .black, radius: 5)
            }
        }
    }
    
    func flagTapped(num: Int) {
        if QuestionNumberID < 8 {
            
            if num == correctAnswer {
                scoreTitle = "Correct"
                playerScore += 1
            } else {
                scoreTitle = "Wrong! That's the flag of \(countries[num])"
            }
            QuestionNumberID += 1
            
        } else {
            
            if num == correctAnswer {
                playerScore += 1
            }
            scoreTitle = "🎉 Congratulations!"
            restartGame = true
        }
        
        showingScore.toggle()
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func gameRestart() {
        playerScore = 0
        QuestionNumberID = 1
        restartGame.toggle()
        askQuestion()
        
    }
        
    var body: some View {
        ZStack {
            RadialGradient(stops: [.init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                                   .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 400).ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .titleModifier()
                
                VStack (spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .titleModifier()
                    }
                    FlagImage
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(playerScore)")
                    .titleModifier()
                Spacer()
            }.padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button(restartGame ? "Start New Game!" : "Continue", action: restartGame ? gameRestart : askQuestion)
        } message: {
            Text(restartGame ? "Your total score is \(playerScore) in \(QuestionNumberID) turns!" : "Your score is \(playerScore)")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
            ContentView()
        }
}
