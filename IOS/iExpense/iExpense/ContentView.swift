//
//  ContentView.swift
//  iExpense
//
//  Created by Rawan Abou Dehn on 29/03/2021.
//

// https://www.hackingwithswift.com/books/ios-swiftui/iexpense-introduction

import SwiftUI

// Identifiable: type can be identified uniqely
// it has one requirement, an id property which contains a unique identifier
// with this in place, we don't need to provide any unique value in ForEach
// Codable protocol: supports archiving and unarchiving
struct ExpenseItem: Identifiable, Codable {
    //let id: UUID // universely uniqe id
    let id = UUID() // generate UUID
    let name: String
    let type: String
    let amount: Int
    
}

// list of expenses
// can load and save and be used by multiple views
class Expenses: ObservableObject{
    // published notifies the UI when there's any update -> to reload
    @Published var items = [ExpenseItem]() {
        // property observer: whenever an item gets added or removed, write our changes
        didSet {
            // 1. create an instance of JSONEncoder
            let encoder = JSONEncoder()
            
            // 2. convert our data to JSON (only possible when Object are Codable)
            if let encoded = try? encoder.encode(items) {
                // 3. write data to UserDefaults using the key Items
                // UserDefaults: save and load the archived data
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    // load saved data whenever a new instance of Expenses is created
    init() {
        // 1. read the items key from UserDefaults
        // UserDefaults: save and load the archived data
        if let items = UserDefaults.standard.data(forKey: "Items") {
            // 2. create an instance of JSONDecoder which converts JSON data to Swift objects
            let decoder = JSONDecoder()
            
            // 3. convert the data we received from UserDefaults into an array of ExpenseItem objects
            // 4. 1) if that worked assign the resulting array to items
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
                return
            }
            
            // 4. 2) Otherwise, set items to be an empty array
            self.items = []
        }
    }
}

struct ContentView: View {
    // observe items, when properties change refresh body
    @ObservedObject var expenses = Expenses()
    
    // is add expense view shown?
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                // display the list, identify each item by its unique id
                //ForEach(expenses.items, id: \.id) { item in
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        
                        Spacer()
                        Text("$\(item.amount)")
                            .foregroundColor(item.amount <= 10 ? Color.green : Color.red)
                    }
                    
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(
                // add Edit/Done button to navigation bar which lets users delete several rows more easily
                leading: EditButton(),
                trailing:
                    Button(action: {
                        //let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5)
                        //self.expenses.items.append(expense)
                        
                        self.showingAddExpense = true
                    }) {
                        Image(systemName: "plus")
                    }
            )
            // open Add view as sheet
            .sheet(isPresented: $showingAddExpense) {
                // show AddView here
                AddView(expenses: self.expenses)
                    
            }
        }
    }
    

    // remove row by index
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
