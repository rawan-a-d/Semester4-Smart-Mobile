//
//  ContentView.swift
//  WeSplit
//
//  Created by Rawan Abou Dehn on 23/03/2021.
//

// https://www.hackingwithswift.com/books/ios-swiftui/wesplit-introduction

import SwiftUI

// ContentView contains the iniitial user interface for the program
struct ContentView: View {
    // Whenever a state variables changes -> revoke body -> reload UI
    @State private var checkAmount = "" // string because we need to display it in the textfield
    @State private var numberOfPeople = 2 // 4
    @State private var tipPercentage = 2 // 20

    let tipPercentages = [10, 15, 20, 25, 0] // list of possible tips
        
    // Calculate how much a person has to pay
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2) // add 2 because number of people starts at 2
        
        let tipSelection = Double(tipPercentages[tipPercentage])
        
        // checkAmount is string
        // convert to double, if successful save the amount and if not save 0
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    var totalAmount: Double {
        let tipSelection = Double(tipPercentages[tipPercentage])
        
        // checkAmount is string
        // convert to double, if successful save the amount and if not save 0
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        
        return grandTotal
    }
    
    var body: some View {
        // Let IOS slide in new views as needed
        NavigationView {
            Form {
                // Reading text from the user with TextField
                Section {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad) // change keyboard to decimal
                    
                    // Picker
                    // to open a view with the options, add NavigationView around Form
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2 ..< 100) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section(header: Text("How much tip do you want to leave")) {
                    //Text("How much tip do you want to leave")
                    // segmented control
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Total amount of check (original amount + tip)
                Section(header: Text("Total amount of check")) {
                    Text("$ \(totalAmount, specifier: "%.2f")")
                }
                
                Section(header: Text("Amount per person")) {
                    Text("$ \(totalPerPerson, specifier: "%.2f")") // show only two numbers after comma
                }
            }
            .navigationBarTitle("WeSplit")
        }
    }
}

// Display the view in the iPhone
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
