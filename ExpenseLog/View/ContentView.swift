//
//  TabView.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-02-27.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ExpenseModel.date, order: .forward) var expenses: [ExpenseModel]
    
    @State private var filterByPayment: PaymentType? = nil
    @State private var filterByCategory: ExpenseCategory? = nil
    
    private var filteredExpenses: [ExpenseModel] {
            expenses.filter { expense in
                let matchesPayment = filterByPayment == nil || expense.paymentType == filterByPayment
                let matchesCategory = filterByCategory == nil || expense.category == filterByCategory
                return matchesPayment && matchesCategory
            }
        }
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "dollarsign.circle.fill")
                    Text("Expenses")
                }
            SummaryView()
                .tabItem {
                    Image(systemName: "chart.pie.fill")
                    Text("Summary")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ExpenseModel.self)
}
