//
//  SummaryView.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-02-27.
//

import SwiftUI
import Charts

enum ChartType: String, CaseIterable, Codable {
    case category
    case paymentType = "Payment Type"
}

struct SummaryView: View {
    
    @StateObject private var viewModel = SummaryViewModel()
    @StateObject private var userViewModel = UserViewModel()
    
    @State private var selectedChartType: ChartType = .category
    @State private var isLoggedOut: Bool = false
    
    var body: some View {
        NavigationStack {
            if !viewModel.expenses.isEmpty {
                VStack {
                    Picker("Chart Type", selection: $selectedChartType) {
                        ForEach(ChartType.allCases, id: \.self) { chartType in
                            Text(chartType.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    if selectedChartType == .category {
                        CategoryChartView(groupedExpenses: viewModel.groupedExpenses)
                    } else {
                        PaymentTypeChartView(expenseByPaymentType: viewModel.expenseByPaymentType)
                    }
                }
                .padding()
                VStack(alignment: .leading, spacing: 20) {
                    Text("Total Expense: $\(String(format: "%.2f", viewModel.totalExpenses))")
                    Text("Average Expense: $\(String(format: "%.2f", viewModel.avgExpense))")
                }
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 10))
                .padding()
                .navigationTitle(Text("Summary"))
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu("", systemImage: "gear") {
                            Button {
                                Task {
                                    do {
                                        try userViewModel.signOut()
                                        isLoggedOut = true
                                    } catch {
                                        print(error)
                                    }
                                }
                            } label: {
                                Text("Log Out")
                                    .foregroundStyle(.blue)
                            }
                            Button(role: .destructive) {
                                Task {
                                    do {
                                        try await userViewModel.deleteUser()
                                        isLoggedOut = true
                                    } catch {
                                        print(error)
                                    }
                                }
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                        }
                    }
                }
                Spacer()
            } else {
                VStack {
                    Text("No Expenses Found")
                        .font(.headline)
                }
                .navigationTitle("Summary")
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchExpenses()
            }
        }
        .fullScreenCover(isPresented: $isLoggedOut) {
            SignInOptionView()
        }
    }
}

#Preview {
    SummaryView()
}
