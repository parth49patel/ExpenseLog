//
//  CategoryChartView.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-03-27.
//

import SwiftUI
import Charts

struct CategoryChartView: View {
    
    let groupedExpenses: [(category: ExpenseCategory, total: Double)]
    
    var body: some View {
        Chart {
            ForEach(groupedExpenses, id: \.category) { data in
                BarMark(x: .value("Category", data.category.rawValue.capitalized),
                        y: .value("Amount", data.total))
                .foregroundStyle(data.category.background)
                .annotation(position: .top) {
                    VStack {
                        Image(systemName: data.category.icon)
                            .imageScale(.large)
                            .foregroundStyle(data.category.background)
                        Text("$\(String(format:"%.2f", data.total))")
                            .font(.subheadline)
                    }
                }
            }
        }
        .frame(height: 400)
        .padding()
    }
}

#Preview {
    CategoryChartView(groupedExpenses: [
        (category: .food, total: 150.5),
        (category: .clothing, total: 120.75),
        (category: .transportation, total: 117.59)
    ])
}
