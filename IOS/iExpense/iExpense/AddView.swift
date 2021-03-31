//
//  AddView.swift
//  iExpense
//
//  Created by Rawan Abou Dehn on 30/03/2021.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // will have the same list as ContentView, and will monitor for changes
    @ObservedObject var expenses: Expenses
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    static let types = ["Business", "Personal"]
    
    @State private var alertShown = false

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    // display types
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing:
                Button("Save") {
                    // cast amount to int
                    if let actualAmount = Int(self.amount) {
                        // create item
                        let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                        
                        // add to list
                        self.expenses.items.append(item)
                        
                        // close this view
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    else {
                        self.alertShown = true
                    }
                }
            )
            // show alert if amount is invalid
            .alert(isPresented: $alertShown) {
                Alert(title: Text("Invalid amount"))
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
