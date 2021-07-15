//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Rawan Abou Dehn on 23/03/2021.
//

import SwiftUI

// create a FlagImage() view that renders one flag image using the specific set of modifiers we had.
struct FlagImage: View {
    var imageName: String
        
    var body: some View {
        Image(imageName)
            .renderingMode(.original) // don't recolor as button
            .clipShape(Capsule()) // change shape
            .overlay(Capsule().stroke(Color.black, lineWidth: 1)) // add border around the flags
            .shadow(color: .black, radius: 2) // add shadow
        
    }
}

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
    
    // animation
    @State private var animationAmount = 0.0
    @State private var animationAmountOpacity: CGFloat = 1
    
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
                        FlagImage(imageName: self.countries[number])
                    }
                    // apply animation to correct answer only
                    .rotation3DEffect(
                        .degrees((number == correctAnswer) ?
                                    animationAmount : 0.0),
                        axis: (x: 0, y: 1, z: 0))
                    // make the other two buttons (wrong ones) fade out to 25% opacity
                    .opacity((number != correctAnswer) ?
                                Double(animationAmountOpacity) : 1)
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
            
            // animate
            withAnimation(
                .interpolatingSpring(stiffness: 5, damping: 1)
            ) {
                animationAmount = 360
            }
            
            withAnimation {
                animationAmountOpacity = 0.5
            }
            
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
        // reset animation
        animationAmountOpacity = 1
        animationAmount = 0
        
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
