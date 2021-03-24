//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Rawan Abou Dehn on 23/03/2021.
//

import SwiftUI

// https://www.hackingwithswift.com/read/2/overview
struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled() // shuffle the array
    // automatically pick random number (country)
    @State private var correctAnswer = Int.random(in: 0...2)
    
    // alert is shown or not
    @State private var showingScore = false
    // store the title which will be shown inside the alert
    @State private var scoreTitle = ""
    
    @State private var score = ""
    
    var body: some View {
        ZStack { // add background color
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack(spacing: 30){
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black) // bold
                }
                
                // Stacking up buttons
                // Show three flags
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        // check answer
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number])
                            .renderingMode(.original) // don't recolor as button
                            .clipShape(Capsule()) // change shape
                            .overlay(Capsule().stroke(Color.black, lineWidth: 1)) // add border around the flags
                            .shadow(color: .black, radius: 2) // add shadow
                    }
                }
                
                Text("Your score is " + score)
                    .foregroundColor(.white)
                
                Spacer() // push text up

            }
        }
        // Show the player score with an alert
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle),
                  message: Text("Your score is " + score),
                  dismissButton:
                    .default(Text("Continue")) {
                        // new question
                        self.askQuestion()
                    })
        }
        
    }
    
    // check if answer is correct
    func flagTapped(_ number: Int) {
        if(number == correctAnswer) {
            scoreTitle = "Correct"
            
            // increase score
            var scoreInt = Int(score) ?? 0
            scoreInt += 3
            
            score = String(scoreInt)
        }
        else {
            scoreTitle = "Wrong, that's the flag of " + countries[number]
            
            // decrease score
            var scoreInt = Int(score) ?? 0
            scoreInt -= 2
            
            score = String(scoreInt)
        }
        
        showingScore = true
    }
    
    // reset when the alert is dismissed
    func askQuestion() {
        // shuffle contries
        countries.shuffle()
        // pick new correct answer
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
