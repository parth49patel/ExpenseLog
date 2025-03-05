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
    @Query(sort: \ExpenseModel.date, order: .forward) var expenses: [ExpenseModel]
    
    @State private var filterByPayment: PaymentType? = nil
    @State private var filterByCategory: ExpenseCategory? = nil
    
    private var filteredExpenses: [ExpenseModel] {
            expenses.filter { expense in
                let matchesPayment = (filterByPayment == nil || expense.paymentType == filterByPayment)
                let matchesCategory = (filterByCategory == nil || expense.category == filterByCategory)
                return matchesPayment && matchesCategory
            }
        }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredExpenses) { expense in
                    NavigationLink(destination: ExpenseDetailView(expense: expense)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(expense.name)
                                    .font(.title)
                                    .textInputAutocapitalization(.words)
                                HStack {
                                    Image(systemName: expense.category.icon)
                                        .foregroundStyle(expense.category.background)
                                    Text(expense.paymentType.rawValue.capitalized)
                                        .font(.subheadline)
                                }
                            }
                            Spacer()
                            Text(expense.amount.description)
                                .font(.system(size: 25, weight: .semibold, design: .default))
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                    }
                }
                .listRowBackground(Rectangle().foregroundStyle(.clear))
            }
            .navigationBarTitle("Expenses")
            //.navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: AddExpenseView()) {
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
                                    Text(category.rawValue.capitalized).tag(category as ExpenseCategory?)
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
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: ExpenseModel.self)
}
