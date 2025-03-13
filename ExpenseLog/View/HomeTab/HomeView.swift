//
//  ContentView.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-01-25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ExpenseModel.date, order: .reverse) var expenses: [ExpenseModel]
    
    @State private var filterByPayment: PaymentType? = nil
    @State private var filterByCategory: ExpenseCategory? = nil
    @State private var showAddExpenseView: Bool = false
    
    private var filteredExpenses: [ExpenseModel] {
            expenses.filter { expense in
                let matchesPayment = (filterByPayment == nil || expense.paymentType == filterByPayment)
                let matchesCategory = (filterByCategory == nil || expense.category == filterByCategory)
                return matchesPayment && matchesCategory
            }
        }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(filteredExpenses) { expense in
                        NavigationLink(destination: ExpenseDetailView(expense: expense)) {
                            ListView(expense: expense)
                                .padding(.horizontal, 10)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationBarTitle("Expenses")
            
            //MARK: Toolbar
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showAddExpenseView.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Menu("Filter by Payment Type") {
                            Picker("Payment Type", selection: $filterByPayment) {
                                Text("All").tag(nil as PaymentType?)
                                ForEach(PaymentType.allCases, id: \.self) { paymentType in
                                    Text(paymentType.rawValue.capitalized).tag(paymentType as PaymentType?)
                                }
                            }
                        }
                        
                        Menu("Filter by Category") {
                            Picker("Category", selection: $filterByCategory) {
                                Text("All").tag(nil as ExpenseCategory?)
                                ForEach(ExpenseCategory.allCases, id: \.self) { category in
                                    Label(category.rawValue.capitalized, systemImage: category.icon)
                                }
                            }
                        }
                        
                        Button("Clear Filters", role: .destructive) {
                            filterByPayment = nil
                            filterByCategory = nil
                        }
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease")
                    }
                }
            }
            //MARK: Sheets
            .sheet(isPresented: $showAddExpenseView) {
                AddExpenseView()
                    //.presentationDetents([.fraction(0.8)])
                    .presentationBackgroundInteraction(.disabled)
                    .presentationContentInteraction(.scrolls)
                    .interactiveDismissDisabled(true)
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: ExpenseModel.self)
}

