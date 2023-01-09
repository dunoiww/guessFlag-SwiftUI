//
//  ContentView.swift
//  guessFlag
//
//  Created by Ngô Nam on 04/01/2023.
//

import SwiftUI

struct Flag: View {
    var text: String
    
    var body: some View {
        Image(text)
            .renderingMode(.original)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color .black, lineWidth: 1))
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var animationAmount: Double = 0
    @State private var opacityAmount: Double = 1
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0

    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()

    @State private var correctAnswer = Int.random(in: 0...2)

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("GUESS THE FLAG")
                    .foregroundColor(.white)
                    .font(.largeTitle.bold())
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.white)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.medium))
                    }
                    ForEach(0..<3) { number in
                        Button(action: {
                            withAnimation {
                                self.flagTapped(number)
                            }
                        }) {
                            Flag(text: self.countries[number])
                        }
                        .rotation3DEffect(.degrees(number == correctAnswer ? animationAmount : 0), axis: (x: 0, y: 0, z: 1))
                        .opacity(number != correctAnswer ? opacityAmount : 1)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Spacer()
                Spacer()

                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            if (scoreTitle == "Correct") {
                Button("Continue", action: askQuestion)
            } else {
                Button("Try again", action: askQuestion)
            }
        }
//        .alert(isPresented: $showingScore) {
//            Alert(title: Text(scoreTitle), dismissButton: .default(Text("Continue")) {
//                self.askQuestion()
//            })
//        }
    }

    func flagTapped(_ number: Int) {
        if (number == correctAnswer) {
            scoreTitle = "Correct"
            score += 1
            animationAmount += 360
            opacityAmount -= 0.75
        } else {
            scoreTitle = "Oops! That is the flag of \(countries[number]). Please try again."
            score = 0
            opacityAmount = 0
        }
        showingScore = true
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        opacityAmount = 1
        animationAmount = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
