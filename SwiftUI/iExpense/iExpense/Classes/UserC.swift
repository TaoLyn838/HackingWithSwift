//
//  UserC.swift
//  iExpense
//
//  Created by CHENGTAO on 7/19/23.
//

import Foundation

// Error: @StateObject need ObservableObject class
//class UserC {

//Fix: add ObservableObject
class UserC: ObservableObject {
    
    // Error: this make view not change!
//    var firstName = "Bilbo"
//    var lastName = "Baggins"
    
    // Fix: add @Published
    @Published var firstName = "Bilbo"
    @Published var lastName = "Baggins"
}
