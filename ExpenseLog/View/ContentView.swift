//
//  TabView.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-02-27.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var expenseManager = ExpenseManager.shared
    
    var body: some View {
        
        TabView {
            if let userId = userViewModel.currentUser?.uid {
                HomeView(userId: userId)
                    .tabItem {
                        Image(systemName: "dollarsign.circle.fill")
                        Text("Expenses")
                    }
                SummaryView()
                    .tabItem {
                        Image(systemName: "chart.bar.xaxis")
                        Text("Summary")
                    }
            }
            
        }
        .tabViewStyle(.sidebarAdaptable)
        .task {
            await loadUserProfile()
            if let userId = userViewModel.currentUser?.uid {
                await expenseManager.loadExpenses(for: userId)
            }
        }
    }
    private func loadUserProfile() async {
        do {
            try await userViewModel.loadCurrentUser()
        } catch {
            print("Error loading user profile: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
