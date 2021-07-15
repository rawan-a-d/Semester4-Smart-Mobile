//
//  ContentView.swift
//  BetterRest
//
//  Created by Rawan Abou Dehn on 25/03/2021.
//

import SwiftUI

// https://www.hackingwithswift.com/books/ios-swiftui/betterrest-introduction
struct ContentView: View {
    @State private var sleepAmount = 8.0 // double value

    @State private var wakeUp = defaultWakeTime // starts at 7 AM

    @State private var coffeeAmount = 1
    
    // alert
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?")) { // groups text and date picker
                    
                    DatePicker("Please enter a time",
                               selection: $wakeUp,
                               displayedComponents: .hourAndMinute)
                        .labelsHidden() // hide label
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section(header: Text("Desires amount of sleep")) {
                    
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                Section(header: Text("Daily coffee intake")) {
                    
                    Stepper(value: $coffeeAmount, in: 1...20) {
                        if(coffeeAmount == 1) {
                            Text("1 cup")
                        }
                        else {
                            Text("\(coffeeAmount) cups")
                        }
                    }
                }
                
            }
            .navigationBarTitle("BetterRest")
            .navigationBarItems(trailing:
                // button to let users calculate the best time they should go to sleep
                // run this funtion when the button is pressed
                Button(action: calculateBedTime) {
                    Text("Calculate")
                }
            )
            // show alert on success or failure
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        
        }
    }

    
    // create defaultWakeTime (starts at 7 AM)
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    
    // method to calculate the best bed time
    func calculateBedTime() {
        // Connecting SwiftUI to Core ML

        // Call the class which was created for us after adding the mlmmodel file
        let model = SleepCalculator()
        
        // get wake up hour and minute
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp) // get hour and minute from wakeUp dateTime
        let hour = (components.hour ?? 0) * 60 * 60 // hour in seconds
        let minute = (components.minute ?? 0) * 60 // minute in seconds
        
        do {
            // Pass the wake up time, estimated sleep and coffee amount
            // returns SleepCalulatorOutput
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            // get when user needs to go to sleep
            print("wakeUp \(wakeUp)") // wakeUp 2021-03-26 13:11:08 +0000
            print("prediction.actualSleep \(prediction.actualSleep)") // 30108.747233607464

            // calulate sleep time -> wake up time - how much sleep the user needs in seconds
            let sleepTime = wakeUp - prediction.actualSleep

            print("sleepTime \(sleepTime)") // 2021-03-26 04:52:53 +0000
            
            // convert date into string
            let formatter = DateFormatter()
            formatter.timeStyle = .short

            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bedtime is…"
        } catch {
            // something went wrong!
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        
        // show alert
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
