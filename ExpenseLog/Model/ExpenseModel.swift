//
//  ExpenseModel.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-01-28.
//

import Foundation
import SwiftData
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
                return "hanger"
            case .grocery:
                return "cart.fill"
            case .other:
                return ""
        }
    }
    
    var background: Color {
        switch self {
            case .food:
                return .orange
            case .transportation:
                return .green
            case .entertainment:
                return .blue
            case .clothing:
                return .brown
            case .grocery:
                return .yellow
            case .other:
                return .gray
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
    case other
}

@Model
final class ExpenseModel {
    var name: String
    var note: String?
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
            PaymentType(rawValue: paymentTypeRawValue) ?? .other
        }
        set {
            paymentTypeRawValue = newValue.rawValue
        }
    }
    
    init(name: String, amount: Double, note: String? = nil, category: ExpenseCategory, paymentType: PaymentType, date: Date) {
        self.name = name
        self.note = note
        self.amount = amount
        self.categoryRawValue = category.rawValue
        self.paymentTypeRawValue = paymentType.rawValue
        self.date = date
    }
}
