//
//  SummaryView.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-02-27.
//

import SwiftUI
import SwiftData
import Charts

enum ChartType: String, CaseIterable {
    case bar
//    case line
//    case pie
    
    var icon: String {
        switch self {
            case .bar:
                return "chart.bar.xaxis"
        }
    }
}

struct SummaryView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query var expenses: [ExpenseModel]
    @State private var selectedChartType: ChartType = .bar
    
    var totalExpenses: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    var avgExpense: Double {
        guard !expenses.isEmpty else { return 0 }
        return totalExpenses / Double(expenses.count)
    }
    var groupedExpenses: [(category: ExpenseCategory, total: Double)] {
        expenses.reduce(into: [:]) { result, expense in
            result[expense.category, default: 0] += expense.amount
        }
        .map { (category, total) in (category, total) }
    }
    
    var body: some View {
        NavigationStack {
//            ScrollView {
                VStack {
                    switch selectedChartType {
                        case .bar:
                            BarChartView(groupedExpenses: groupedExpenses)
//                        case .pie:
//                            SectorChartView(groupedExpenses: groupedExpenses)
//                        case .line:
//                            LineChartView(groupedExpenses: groupedExpenses)
                    }
                }
                VStack(alignment: .leading, spacing: 20) {
                    Text("Total Expense: $\(String(format: "%.2f", totalExpenses))")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                    Text("Average Expense: $\(String(format: "%.2f", avgExpense))")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 10))
                .padding()
//            }
            .navigationTitle(Text("Summary"))
            Spacer()
//            .toolbar {
//                ToolbarItem(placement: .automatic) {
//                    Menu {
//                        Picker("Chart Type", selection: $selectedChartType) {
//                            ForEach(ChartType.allCases, id: \.self) { type in
//                                HStack {
//                                    Text(type.rawValue.capitalized)
//                                    Image(systemName: type.icon)
//                                }
//                            }
//                        }
//                    } label: {
//                        Image(systemName: "ellipsis.circle")
//                    }
//                }
//            }
        }
    }
}

//MARK: Bar Chart
struct BarChartView: View {
    
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

//MARK: Sector Chart
//struct SectorChartView: View {
//    
//    let groupedExpenses: [(category: ExpenseCategory, total: Double)]
//    
//    var body: some View {
//        Chart {
//            ForEach(groupedExpenses, id: \.category) { data in
//                SectorMark(
//                    angle: .value("Value", data.total),
//                    innerRadius: .ratio(0.001),
//                    outerRadius: .inset(1),
//                    angularInset: 1
//                )
//                .cornerRadius(4)
//                .foregroundStyle(data.category.background)
//            }
//        }
//        .frame(height: 400)
//        .padding()
//        
//        HStack(spacing: 20) {
//            ForEach(groupedExpenses, id: \.category) { data in
//                VStack(alignment: .center) {
//                        Circle()
//                            .fill(.clear)
//                            .frame(width: 15, height: 15)
//                            .overlay {
//                                Image(systemName: data.category.icon)
//                                    .foregroundStyle(data.category.background)
//                            }
//                    Text(data.category.rawValue.capitalized)
//                        .font(.caption)
//                        .minimumScaleFactor(0.5)
//                        .lineLimit(1)
//                    Text("$\(String(format:"%.2f", data.total))")
//                    }
//                }
//        }
//        .padding(.horizontal, 5)
//    }
//}

//MARK: Line Chart
//struct LineChartView: View {
//    
//    let groupedExpenses: [(category: ExpenseCategory, total: Double)]
//    
//    var body: some View {
//        Chart {
//            ForEach(groupedExpenses, id: \.category) { data in
//                LineMark(
//                    x: .value("Category", data.category.rawValue.capitalized),
//                    y: .value("Amount", data.total)
//                )
//            }
//            
//        }
//    }
//}
#Preview {
    SummaryView()
        .modelContainer(for: ExpenseModel.self)
}
