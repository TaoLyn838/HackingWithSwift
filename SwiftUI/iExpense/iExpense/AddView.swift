//
//  AddView.swift
//  iExpense
//
//  Created by CHENGTAO on 7/27/23.
//

import SwiftUI

struct AddView: View {
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    @ObservedObject var expenses: Expenses

    let types = ["Business", "Personal"]

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
        }
    }
}

struct MakingChangesPermanentWithUserDefault: View {
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    @ObservedObject var expenses: Expenses
    @Environment(\.dismiss) var dismiss
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button {
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(item)
                    dismiss()
                } label: {
                    Image(systemName: "square.and.arrow.down")
                }
            }
            
        }
    }
}

//struct AddView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddView(expenses: Expenses())
//    }
//}
