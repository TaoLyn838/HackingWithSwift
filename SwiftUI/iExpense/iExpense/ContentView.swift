//
//  ContentView.swift
//  iExpense
//
//  Created by CHENGTAO on 7/18/23.
//

///Goal
///Our next two projects are going to start pushing your SwiftUI skills beyond the basics, as we explore apps that have multiple screens, that load and save user data, and have more complex user interfaces.
///In this project we’re going to build iExpense, which is an expense tracker that separates personal costs from business costs. At its core this is an app with a form (how much did you spend?) and a list (here are the amounts you spent), but in order to accomplish those two things you’re going to need to learn how to:
/// • Present and dismiss a second screen of data.
/// • Delete rows from a list
/// • Save and load user data

import SwiftUI

struct ContentView: View {
    var body: some View {
        FinalPolish()
    }
}

/// Uncomment "User #1" (at line 10) in Model folder at User file (Model -> User)   before uncomment bellowing
/// line because we need `var` type of `User` instances to change value in `TextField()`
//struct WhyStateOnlyWorksWithStructs: View {
//    @State private var user = User(firstName: "Bilbo", lastName: "Baggins")
//    @State private var user1 = UserC()
//    var body: some View {
//        VStack {
//            Text("Your name is \(user.firstName) \(user.lastName)")
//            TextField("First name", text: $user.firstName)
//            TextField("Last name", text: $user.lastName)
//
//            Text("Your name is \(user1.firstName) \(user1.lastName)")
//
//            // Text View would not change while user typing
//            TextField("First name", text: $user1.firstName)
//            TextField("Last name", text: $user1.lastName)
//        }
//    }
//}

struct SharingSwiftUIStateWithStateObj: View {
//    @State private var user = UserC()
    @StateObject var user = UserC()

    var body: some View {
        VStack {
            Text("Your name is \(user.firstName) \(user.lastName)")
            TextField("First name", text: $user.firstName)
            TextField("Last name", text: $user.lastName)
        }
    }
}

struct ShowingAndHidingViews: View {
    @State private var showSheet = false
    var body: some View {
        Button ("Show Sheet") {
            showSheet.toggle()
        }.sheet(isPresented: $showSheet) {
            SecondView(name: "Chengtao's")
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

// Second View in ShowingAndHidingViews part
struct SecondView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let name: String
    
    var body: some View {
        Button("Dismiss") {
            dismiss()
        }
    }
}

struct DeletingItemsUsingOnDele: View {
    @State private var numbers = [Int]()
    @State private var currentNumber = 1
    
    func removeRows(at offsets: IndexSet) {
        numbers.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(numbers, id: \.self) {
                        Text("Row \($0)")
                    }
                    .onDelete(perform: removeRows)
                }
                
                Button("Add Number") {
                    numbers.append(currentNumber)
                    currentNumber += 1
                }
            }
            .navigationTitle("onDelete()")
            .toolbar {
                EditButton()
            }
        }
    }
}

struct StoringUserSettingsWithUserDefaults: View {
//    @State private var tapCount = UserDefaults.standard.integer(forKey: "Tap")
    
    // use AppStorage do the same job as UserDefaults(). It help you make code clear!
    @AppStorage("Tap") private var tapCount = 0
    
    var body: some View {
        Button("Tap count \(tapCount)") {
            tapCount += 1
//            UserDefaults.standard.set(tapCount, forKey: "Tap")
        }
    }
}

struct ArchivingSwiftObjectsWithCodable: View {
    @State private var user = User(firstName: "Chengtao", lastName: "Lin")
    
    var body: some View {
//        print(user)
        return VStack {
            Button("Save User") {
                let encoder = JSONEncoder()
                
                if let data = try? encoder.encode(user) {
                    UserDefaults.standard.set(data, forKey: "UserData")
                }
            }
        }
    }
}

struct BuildingListWeCanDeleteFrom: View {
    @StateObject var expenses = Expenses()
    
    func removeItem(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items, id:\.name) { item in
                    Text(item.name)
                }
                .onDelete(perform: removeItem)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5)
                    expenses.items.append(expense)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct WorkingWithIdentifiableItemsInSwiftUI: View {
    @StateObject var expenses = Expenses()
    
    func removeItem(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items) { item in
                    Text(item.name)
                }
                .onDelete(perform: removeItem)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5)
                    expenses.items.append(expense)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct SharingAnObservedOjbWithNewView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    func removeItem(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items) { item in
                    Text(item.name)
                }
                .onDelete(perform: removeItem)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
//                AddView(expenses: expenses)
                MakingChangesPermanentWithUserDefault(expenses: expenses)
            }
        }
    }
}


struct FinalPolish: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    func removeItem(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        
                        Spacer()
                        Text(item.amount, format: .currency(code: "USD"))
                    }
                }
                .onDelete(perform: removeItem)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
//                AddView(expenses: expenses)
                MakingChangesPermanentWithUserDefault(expenses: expenses)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
