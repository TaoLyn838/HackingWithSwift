//
//  ContentView.swift
//  BetterRest
//
//  Created by CHENGTAO on 7/9/23.
//

// Use machine learning to improve sleep
import SwiftUI
import CoreML

struct ContentView: View {
    var body: some View {
        CleaningUpTheUserInterface()
    }
}

struct EnteringNumberWithStepper: View {
    @State private var sleepAmount = 8.0
    var body: some View {
        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
    }
}

struct SelectingDatesAndTimesWithDatePicker: View {
    @State private var wakeUp = Date.now
    var body: some View {
        //        DatePicker("", selection: $wakeUp, displayedComponents: .hourAndMinute)
        //            .labelsHidden()
        
//                let tomorrow = Date.now.addingTimeInterval(86400)
//                let range = Date.now...tomorrow
        DatePicker("", selection: $wakeUp, in: Date.now...)
                    .labelsHidden()
            
    }
}

struct WorkingWithDates: View {
    var body: some View {
//        Text(Date.now, format: .dateTime.hour().minute().year())
        Text(Date.now.formatted(date: .long, time: .omitted))
    }
}

//func trivialExample() {
////    var components = DateComponents()
////    components.hour = 8
////    components.minute = 0
//    // use nil (?? Date.now) to go back to current day while optional date is failed
////    let date  = Calendar.current.date(from: components) ?? Date.now
//
//    // Second way
//    let components = Calendar.current.dateComponents([.hour, .minute], from: Date.now)
//    let hour = components.hour ?? 0
//    let minute = components.minute ?? 0
//
//}
//

//struct TrainingModelWithCreateML: View {
//    var body: some View {
//        // go to BetterRestML file
//    }
//}

struct BuildingBasicLayout: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
    @State private var coffeeAmount = 1
    
    var body: some View {
        /// NavigationStack is super important!!! DON"T FROGET
        NavigationStack {
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                Text("Desired amount of sleep")
                    .font(.headline)
                
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                
                Text("Daily coffee intake")
                    .font(.headline)
                
                Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedtime)
            }
        }
    }
    func calculateBedtime() {
        
    }
}

struct ConnectingSwiftUIToCoreML: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
    @State private var coffeeAmount = 1
    @State private var alertTile = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        /// NavigationStack is super important!!! DON"T FROGET
        NavigationStack {
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                Text("Desired amount of sleep")
                    .font(.headline)
                
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                
                Text("Daily coffee intake")
                    .font(.headline)
                
                Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedtime)
            }
            .alert(alertTile, isPresented: $showingAlert) {
                Button("OK") {}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: Double(sleepAmount), coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            alertTile = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            alertTile = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
            
        }
        showingAlert = true
    }
    
}


struct CleaningUpTheUserInterface: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeUpTime
    @State private var coffeeAmount = 1
//    @State private var alertTile = ""
//    @State private var alertMessage = ""
//    @State private var showingAlert = false
    @State private var userBedtimeTitle = ""
    @State private var recommendedBedTimeMessage = ""
    
    static var defaultWakeUpTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    
    var body: some View {
        /// NavigationStack is super important!!! DON"T FROGET
        NavigationStack {
            Form {
//                VStack (alignment: .leading, spacing: 10) {
                Section("When do you want to wake up") {
//                    Text("When do you want to wake up?")
//                        .font(.headline)
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
//                        .labelsHidden()
                }
                
//                VStack (alignment: .leading, spacing: 10) {
                Section("Desired amount of sleep") {
//                    Text("Desired amount of sleep")
//                        .font(.headline)
                    
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
//                VStack (alignment: .leading, spacing: 10) {
                Section("Daily coffee intake") {
//                    Text("Daily coffee intake")
//                        .font(.headline)
                    
//                    Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                    Picker(coffeeAmount == 1 ? "Cup" : "Cups", selection: $coffeeAmount) {
                        ForEach(1..<21, id: \.self) {
                            Text("\($0)")
                        }
                    }
                }
                
                Section(userBedtimeTitle) {
                    HStack {
                        Spacer()
                        Text(recommendedBedTimeMessage)
                        Spacer()
                    }
                }
            }
            .navigationTitle("BetterRest")
            .onAppear(perform: calculateUserBedtime)
//            .toolbar {
//                Button("Calculate", action: calculateBedtime)
//            }
//            .alert(alertTile, isPresented: $showingAlert) {
//                Button("OK") {}
//            } message: {
//                Text(alertMessage)
//            }
        }
    }
    
    func calculateUserBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: Double(sleepAmount), coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            userBedtimeTitle = "Your ideal bedtime is..."
            recommendedBedTimeMessage = sleepTime.formatted(date: .abbreviated, time: .standard)
            
        } catch {
            recommendedBedTimeMessage = "Sorry, we have errors to calculate your bedtime."
            
        }
    }
    
//    func calculateBedtime() {
//        do {
//            let config = MLModelConfiguration()
//            let model = try SleepCalculator(configuration: config)
//
//            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
//            let hour = (components.hour ?? 0) * 60 * 60
//            let minute = (components.minute ?? 0) * 60
//
//            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: Double(sleepAmount), coffee: Double(coffeeAmount))
//
//            let sleepTime = wakeUp - prediction.actualSleep
//            alertTile = "Your ideal bedtime is..."
//            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
//
//        } catch {
//            alertTile = "Error"
//            alertMessage = "Sorry, there was a problem calculating your bedtime."
//
//        }
//        showingAlert = true
//    }
    
}


//extension View {
//    func mainScreen(wakeUp: @State, sleepAmount: @State, coffeeAmount: @State) -> some View {
//        VStack{
//            Text("When do you want to wake up?")
//                .font(.headline)
//
//            DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
//                .labelsHidden()
//
//            Text("Desired amount of sleep")
//                .font(.headline)
//
//            Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
//
//            Text("Daily coffee intake")
//                .font(.headline)
//
//            Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
//
//
//        }
//    }
//}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
