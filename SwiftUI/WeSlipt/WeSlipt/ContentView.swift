//
//  ContentView.swift
//  WeSlipt
//
//  Created by CHENGTAO on 6/22/23.
//

import SwiftUI

//struct ContentView: View {
//    @State private var change: Bool = false
//    private let unchanged: Bool = true
//    var body: some View {
//        Button("show the sheet view") {
////            change = !change
//            change.toggle()
//        }
//        .sheet(isPresented: $change){
//            Text("HELLO, world")
//        }
//    }
//}

struct ContentView: View {
    @State private var checkAmount = 0.0
     @State private var numberOfPeople = 2
     @State private var tipPercentage = 20
     
     @FocusState private var amountIsFocused: Bool
     
     var totalPerPerson: Double {
         let peopleCount = Double(numberOfPeople)
         let tipSelection = Double(tipPercentage)
         let tipValue = checkAmount / 100 * tipSelection
         let grandTotal = checkAmount + tipValue
         let amountPerPerson = grandTotal / peopleCount
         return amountPerPerson
     }
    
    var totalCheckAmount: Double {
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let totalAmount = grandTotal
        return totalAmount
    }
     
     var body: some View {
         NavigationStack {
             Form {
                 Section {
                     // Updated code with currency.identifier
                     TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                         .keyboardType(.decimalPad)
                         .accessibilityLabel("Label")
                         .focused($amountIsFocused)
                     
                     Picker("Number of people", selection: $numberOfPeople){
                         ForEach(2..<100, id: \.self) {
                             Text("\($0) people")
                         }
                     }
                 }
                 Section {
                     Picker("Tip percentage", selection: $tipPercentage) {
                         ForEach(0..<101, id: \.self) {
                             Text($0, format: .percent)
                         }
                     }.pickerStyle(.navigationLink)
                 } header: {
                     Text("How much tips do you want to leave?")
                 }
                 
                 Section {
                     Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                 } header: {
                     HStack {
                         Image(systemName: "person.fill")
                         Text("Amount per person")
                     }
                 }
                 
                 Section {
                     Text(totalCheckAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                         .foregroundStyle(tipPercentage == 0 ? .red : .primary)
                 } header: {
                     HStack {
                         Image(systemName: "person.2.fill")
                         Text("Total amount for the check")
                     }
                 }
                 
             }.navigationTitle("WeSplit")
                 .toolbar {
                     ToolbarItemGroup(placement: .keyboard) {
                         Spacer()
                         Button("Done") {
                             amountIsFocused = false
                         }
                     }
                 }
         }
     }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
