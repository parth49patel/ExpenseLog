//
//  SummaryViewModel.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-03-27.
//

import Foundation
import FirebaseFirestore

@MainActor
class SummaryViewModel: ObservableObject {
    
    @Published var expenses: [ExpenseModel] = []
    @Published var groupedExpenses: [(category: ExpenseCategory, total: Double)] = []
    @Published var expenseByPaymentType: [(paymentType: PaymentType, total: Double)] = []
    
    var totalExpenses: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    var avgExpense: Double {
        expenses.isEmpty ? 0 : totalExpenses / Double(expenses.count)
    }
    
    private let expenseManager = ExpenseManager.shared
    
    init() {
        Task {
            await fetchExpenses()
        }
    }
    
    func fetchExpenses() async {
        Task {
            do {
                let userId = try await getCurrentUserId()
                let fetchedExpenses = try await expenseManager.fetchExpenses(for: userId)
                self.expenses = fetchedExpenses
                processGroupedExpenses()
                processExpenseByPaymentType()
            } catch {
                print("Error fetching expenses: \(error.localizedDescription)")
            }
        }
    }
    
    // Async method to fetch current user ID
    private func getCurrentUserId() async throws -> String {
        guard let user = UserViewModel.shared.currentUser else {
            throw URLError(.badServerResponse)
        }
        return user.uid
    }
    
    private func processGroupedExpenses() {
        let grouped = Dictionary(grouping: expenses, by: { $0.category })
        self.groupedExpenses = grouped.map { (category, expenses) in
            (category, expenses.reduce(0) { $0 + $1.amount })
        }
        .sorted { $0.category.rawValue < $1.category.rawValue }
    }
    
    private func processExpenseByPaymentType() {
        let grouped = Dictionary(grouping: expenses, by: { $0.paymentType })
        self.expenseByPaymentType = grouped.map { (paymentType, expenses) in
            (paymentType, expenses.reduce(0) { $0 + $1.amount })
        }
        .sorted { $0.paymentType.rawValue < $1.paymentType.rawValue }
    }
    
}
