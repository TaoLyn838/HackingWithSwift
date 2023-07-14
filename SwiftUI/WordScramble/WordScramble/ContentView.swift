//
//  ContentView.swift
//  WordScramble
//
//  Created by CHENGTAO on 7/11/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ValidatingWordsWithUITextChecker()
    }
}

struct IntroducingListYourBestFriend: View {
    var body: some View {
        /// Static
//        List {
//            Text("Hello World")
//            Text("Hello World")
//            Text("Hello World")
//        }
        /// Dynamic
//        List {
//            ForEach (0..<5, id: \.self) {
//                Text("Dynamic row \($0)")
//            }
//        }
        /// Static plus Dynamic
//        List {
//            ForEach (0..<3, id: \.self) {
//                Text("Dynamic row \($0)")
//            }
//            Text("Static row 3")
//            Text("Static row 4")
//        }
        /// Add section make it better! (easier to read)
//        List {
//            Section("Section 1") {
//                ForEach (0..<3, id: \.self) {
//                    Text("Dynamic row \($0)")
//                }
//            }
//            Section("Section 2") {
//                Text("Static row 3")
//                Text("Static row 4")
//            }
//        }
//        .listStyle(.grouped)
        
        /// Simple way to do ForEach to create a dynamic list
        List (0..<5, id: \.self) {
            Text("Dynamic row \($0)")
        }
        .listStyle(.grouped)
    }
}

//struct LoadingResourcesFromYourAppBundle: View {
//    var body: some View {
//    }
//
//    func loadFile() {
//        if let fileURL = Bundle.main.url(forResource: "some-file", withExtension: "txt") {
//            // Here we found the file in our bundle!
//            if let fileContents = try? String(contentsOf: fileURL) {
//                // we loaded the file into a string!
//                fileContents
//            }
//        }
//    }
//}

//struct WorkingWithStrings: View {
//    var body: some View {
//
//    }
//    func test() {
//        let input1 = "a b c"
//        let letters = input1.components(separatedBy: " ")
//        let input2 = """
//a
//b
//c
//"""
//        let letters2 = input2.components(separatedBy: "\n") // return  ["a", "b", "c"]
//        let letter = letters.randomElement()
//
//        let trimmed = letter?.trimmingCharacters(in: .whitespacesAndNewlines) // Optional("b") if randomElement is 'b'
//
//        /// Run bellowing code using Playground
//        let word = "swift"
//        let checker = UITextChecker()
//        let range = NSRange(location: 0, length: word.utf16.count)
//        let missSpelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
//        let allGood = missSpelledRange.location == NSNotFound
//
//     }
//}

struct AddingToListOfWords: View {
    @State private var usedWords = [String] ()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.none)
                }
                Section {
                    ForEach (usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle.fill")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
        }
    }
}

struct RunningCodeWhenAppLaunches: View {
    @State private var usedWords = [String] ()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
    
    func startGame() {
        if let startWordURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWord = try? String(contentsOf: startWordURL) {
                let allWords = startWord.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silKworm"
                return
            }
        }
        fatalError("Could not load start.txt from bundle")
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.none)
                }
                Section {
                    ForEach (usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle.fill")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
        }
    }
}

struct ValidatingWordsWithUITextChecker: View {
    @State private var usedWords = [String] ()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var userScore = 0
    
    // handle alert
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    func startGame() {
        if let startWordURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWord = try? String(contentsOf: startWordURL) {
                let allWords = startWord.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silKworm"
                userScore = 0
                return
            }
        }
        fatalError("Could not load start.txt from bundle")
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 2 else {
            wordError(title: "letter limit", message: "you can not enter words that shorter than 3 letters")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can not spell that word from `\(rootWord)`!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can not just make them up, you know!")
            return
        }
        
        userScore += 1
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let missSpelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return missSpelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
        
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.none)
                }
                
                Section {
                    HStack {
                        Spacer()
                        Text("Your score is \(userScore)")
                            .labelsHidden()
                            .font(.body.bold())
                        Spacer()
                    }
                }
                
                Section {
                    ForEach (usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle.fill")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .toolbar {
                Button("Start New Game", action: startGame)
            }
            .alert(errorTitle, isPresented: $showingError) {
                Button("Ok", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
