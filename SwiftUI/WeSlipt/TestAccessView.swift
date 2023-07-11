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
     
     let tipPercentages = [10, 15, 20, 25, 0]
     var body: some View {
         
         Form {
             Section {
                 // Updated code with currency.identifier
                 TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                     .keyboardType(.decimalPad)
                     .accessibilityLabel(/*@START_MENU_TOKEN@*/"Label"/*@END_MENU_TOKEN@*/)
                 Picker("Number of people", selection: $numberOfPeople){
                     ForEach(2..<100, id: \.self) {
                         Text("\($0) people")
                     }
                 }
             }
             Section {
                 Picker("Tip percentage", selection: $tipPercentage) {
                     ForEach(tipPercentages, id: \.self) {
                         Text($0, format: .percent)
                     }
                 }.pickerStyle(.segmented)
             } header: {
                 Text("How much tips do you want to leave?")
             }
             
             Section {
                 Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
