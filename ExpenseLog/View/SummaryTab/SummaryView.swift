//
//  SummaryView.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-02-27.
//

import SwiftUI
import SwiftData
import Charts

struct SummaryView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query var expenses: [ExpenseModel]
    
    var groupedExpenses: [(category: ExpenseCategory, total: Double)] {
        expenses.reduce(into: [:]) { result, expense in
            result[expense.category, default: 0] += expense.amount
        }
        .map { (category, total) in (category, total) }
    }
    
    var body: some View {
        NavigationStack {
            Chart {
                ForEach(groupedExpenses, id: \.category) { data in
                    BarMark(x: .value("Category", data.category.rawValue.capitalized),
                            y: .value("Amount", data.total))
                    .foregroundStyle(data.category.background)
                    .annotation(position: .automatic) {
                        Image(systemName: data.category.icon)
                            .imageScale(.large)
                            .foregroundStyle(data.category.background)
                    }
                }
            }
            .frame(height: 300)
            .padding()
            Chart {
                ForEach(groupedExpenses, id: \.category) { data in
                    
                }
            }
            .navigationTitle(Text("Summary"))
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
    }
}

#Preview {
    SummaryView()
        .modelContainer(for: ExpenseModel.self)
}
