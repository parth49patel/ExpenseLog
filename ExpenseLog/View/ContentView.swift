//
//  ContentView.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-01-25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ExpenseModel.date, order: .forward) var expenses: [ExpenseModel]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses) { expense in
                    NavigationLink(destination: ExpenseDetailView(expense: expense)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(expense.name)
                                    .font(.title)
                                    .textInputAutocapitalization(.words)
                                HStack {
                                    Text(expense.categoryRawValue.capitalized)
                                        .font(.subheadline)
                                        .foregroundStyle(expense.category.background)
                                    Image(systemName: expense.category.icon)
                                        .foregroundStyle(expense.category.background)
                                }
                            }
                            Spacer()
                            Text(expense.amount.description)
                                .font(.system(size: 25, weight: .semibold, design: .default))
                        }
                    }
                    
                }
            }
            .navigationBarTitle("Expenses")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: AddExpenseView()) {
                        Image(systemName: "plus")
                    }
                }
//                ToolbarItem(placement: .topBarTrailing) {
//                    Image(systemName: "gear")
//                        .foregroundStyle(.blue)
//                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ExpenseModel.self)
    
}
//                .onDelete { indexSet in
//                    indexSet.forEach {
//                        modelContext.delete(expenses[$0])
//                    }
//                }
