//
//  ContentView.swift
//  WordScramble
//
//  Created by Rawan Abou Dehn on 26/03/2021.
//

// https://www.hackingwithswift.com/books/ios-swiftui/word-scramble-introduction
import SwiftUI

struct ContentView: View {
    // words user already used
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    // alert
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    // score
    @State private var totalScore = 0
    @State private var score = 0
    
    var body: some View {
        // Adding to a list of words
        NavigationView {
            VStack {
                // call addNewWord on return press
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle()) // add border
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .padding()
                
                List(usedWords, id: \.self) {
                    Image(systemName: "\($0.count).circle") // a circle with the number of letters
                    Text($0)
                }
                .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                
                // show score
                Text("Score for this word:  \(score)")
                Text("Total score:  \(totalScore)")
            }
            .navigationBarTitle(rootWord)
            // start game, so users can restart with a new word whenever they want to.
            .navigationBarItems(leading:
                Button("Start Game") {
                    startGame()
                }
            )
            // call startGame when the view iis shown
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            
        }
    }
    
    func addNewWord() {
        // lowercase and trim the word, to make sure we don't add duplicate words with case differences
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // exit if the remaining string is empty
        guard answer.count > 0 else {
            return
        }
        
        // extra validation to come
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word is not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word")
            return
        }
        
        // add word at the start of the array
        usedWords.insert(answer, at: 0)
        
        // show score
        score += answer.count
        totalScore += answer.count
        
        // reset newWord
        newWord = ""
    }
    
    // Running code when our app launches
    func startGame() {
        // empty list and score
        usedWords.removeAll()
        score = 0

        // 1. Find the URL for start.txt in our app bundle
        if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // 2. Load start.txt into a string
            if let startWords = try?
                String(contentsOf: startWordsUrl) {
                // 3. Split the string up into an array of strings, splitting on line breaks
                let allWords = startWords.components(separatedBy: "\n")
                // 4. Pick one random word, or use "silkworm" as a sensible default
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
            
        }
        
        // there was a problem, trigger a crash and report the error
        fatalError("Could not load start.txt from bundle.")
    }
    
    
    // Validating words with UITextChecker
    // check if word was used before
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    // check if word iis possible from the roor word
    func isPossible(word: String ) -> Bool {
        var tempWord = rootWord.lowercased()
        
        for letter in word {
            if(!tempWord.contains(letter)) {
                return false
            }
            
//            if let pos = tempWord.firstIndex(of: letter) {
//                tempWord.remove(at: pos)
//            }
//            else {
//                return false
//            }
        }
        
        return true
    }
    
    // check if word is real
    func isReal(word: String) -> Bool {
        // if word is under three letters or user entered same root word
        if(word.count < 3 || word == rootWord) {
            return false
        }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    // show error
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
