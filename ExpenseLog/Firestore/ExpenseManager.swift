//
//  ExpenseManager.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-04-05.
//

import Foundation
import FirebaseFirestore
import SwiftUI

enum ExpenseCategory: String, CaseIterable, Codable {
    case food
    case transportation
    case entertainment
    case clothing
    case grocery
    case other
    
    var icon: String {
        switch self {
            case .food:
                return "fork.knife.circle.fill"
            case .transportation:
                return "car.circle.fill"
            case .entertainment:
                return "movieclapper.fill"
            case .clothing:
                return "tshirt.circle.fill"
            case .grocery:
                return "cart.circle.fill"
            case .other:
                return "giftcard.fill"
        }
    }
    
    var background: Color {
        switch self {
            case .food:
                return .orange
            case .transportation:
                return .green
            case .entertainment:
                return .teal
            case .clothing:
                return .indigo
            case .grocery:
                return .yellow
            case .other:
                return .brown
        }
    }
}

enum PaymentType: String, CaseIterable, Codable {
    case debit
    case visa
    case mastercard
    case amex = "American Express"
    case discover
    case cash
    
    var background: Color {
        switch self {
            case .debit:
                return .yellow
            case .visa:
                return .green
            case .mastercard:
                return .red
            case .amex:
                return .blue
            case .discover:
                return .purple
            case .cash:
                return .gray
        }
    }
}

struct ExpenseModel: Identifiable, Codable {
    
    var id: String? = UUID().uuidString
    var userId: String
    var name: String
    var amount: Double
    var categoryRawValue: String
    var paymentTypeRawValue: String
    var date: Date
    
    var category: ExpenseCategory {
        get {
            ExpenseCategory(rawValue: categoryRawValue) ?? .other
        }
        set {
            categoryRawValue = newValue.rawValue
        }
    }
    
    var paymentType: PaymentType {
        get {
            PaymentType(rawValue: paymentTypeRawValue) ?? .cash
        }
        set {
            paymentTypeRawValue = newValue.rawValue
        }
    }
    
    init(id: String? = UUID().uuidString, userId: String, name: String, amount: Double, category: ExpenseCategory, paymentType: PaymentType, date: Date) {
        self.id = id
        self.userId = userId
        self.name = name
        self.amount = amount
        self.categoryRawValue = category.rawValue
        self.paymentTypeRawValue = paymentType.rawValue
        self.date = date
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case name
        case note
        case amount
        case categoryRawValue
        case paymentTypeRawValue
        case date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.name = try container.decode(String.self, forKey: .name)
        self.amount = try container.decode(Double.self, forKey: .amount)
        self.categoryRawValue = try container.decode(String.self, forKey: .categoryRawValue)
        self.paymentTypeRawValue = try container.decode(String.self, forKey: .paymentTypeRawValue)
        self.date = try container.decode(Date.self, forKey: .date)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(name, forKey: .name)
        try container.encode(amount, forKey: .amount)
        try container.encode(categoryRawValue, forKey: .categoryRawValue)
        try container.encode(paymentTypeRawValue, forKey: .paymentTypeRawValue)
        try container.encode(date, forKey: .date)
    }
}

final class ExpenseManager: ObservableObject {
    
    static let shared = ExpenseManager()
    
    private var expenseCollection: CollectionReference {
        return Firestore.firestore().collection("expenses")
    }
    
    @Published var expenses: [ExpenseModel] = []
    
    // MARK: - Update Expenses
    func updateExpenses(_ expenses: [ExpenseModel]) {
        DispatchQueue.main.async {
            self.expenses = expenses
        }
    }
    
    // MARK: - Create Expense
    func createExpense(userId: String, expense: ExpenseModel) async throws {
        var newExpense = expense
        newExpense.userId = userId
        newExpense.date = Date()
        
        guard let id = newExpense.id else {
            throw NSError(domain: "ExpenseManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Expense ID is nil."])
        }
        let finalExpense = newExpense
        try expenseCollection.document(id).setData(from: finalExpense)
        await MainActor.run {
            expenses.insert(finalExpense, at: 0)
        }
    }
    
    // MARK: - Load All Expenses for a User
    func loadExpenses(for userId: String) async {
        do {
            let fetchedExpenses = try await fetchExpenses(for: userId)
            await MainActor.run {
                self.updateExpenses(fetchedExpenses)
            }
        } catch {
            print("Error fetching expenses: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Fetch All Expenses for a User
    func fetchExpenses(for userId: String) async throws -> [ExpenseModel] {
        let snapshot = try await expenseCollection
            .whereField("user_id", isEqualTo: userId)
            .order(by: "date", descending: true)
            .getDocuments()
        
        return try snapshot.documents.compactMap {
            try $0.data(as: ExpenseModel.self)
        }
    }
    
    // MARK: - Update Expense
    func saveEditedExpense(userId: String, expense: ExpenseModel) async throws {
        var updatedExpense = expense
        updatedExpense.userId = userId
        
        guard let id = updatedExpense.id else {
            throw NSError(domain: "ExpenseManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Expense ID is nil."])
        }
        try expenseCollection.document(id).setData(from: updatedExpense, merge: true)
        let copiedExpense = updatedExpense
        await MainActor.run {
            if let index = expenses.firstIndex(where: { $0.id == copiedExpense.id }) {
                expenses[index] = copiedExpense
            }
        }
    }
    
    // MARK: - Delete Expense
    func deleteExpense(id: String) async throws {
        try await expenseCollection.document(id).delete()
        await MainActor.run {
            expenses.removeAll { $0.id == id }
        }
    }
}
