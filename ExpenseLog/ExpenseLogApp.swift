//
//  ExpenseLogApp.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-01-25.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

@main
struct ExpenseLogApp: App {
    
    init() {
        FirebaseApp.configure()
        print("Configured Firebase")
    }
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(UserViewModel.shared)
        }
    }
}
