//
//  EditView.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-02-05.
//

import SwiftUI
import SwiftData

struct EditView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Bindable var expense: ExpenseModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $expense.name)
                    TextField("Add a note here...", text:
                                Binding(get: { expense.note ?? ""},
                                        set: { expense.note = $0.isEmpty ? nil : $0}))
                }
                Section {
                    HStack {
                        Text("Amount: ")
                        TextField("", value: $expense.amount, format: .number)
                            .keyboardType(.decimalPad)
                    }
                }
                Section {
                    HStack {
                        DatePicker("Expense Date", selection: $expense.date, in: ...Date.now, displayedComponents: .date)
                            .datePickerStyle(.compact)
                    }
                }
                Section {
                    Picker("Category", selection: $expense.category) {
                        ForEach(ExpenseCategory.allCases, id: \.self) { category in
                            Label(category.rawValue.capitalized, systemImage: category.icon)
                        }
                    }
                    Picker("Payment Type", selection: $expense.paymentType) {
                        ForEach(PaymentType.allCases, id: \.self) { paymentType in
                            Text(paymentType.rawValue.capitalized)
                        }
                    }
                }
            }
            .navigationTitle("Edit Expense")
        }
    }
}

#Preview {
    EditView(expense: ExpenseModel(name: "Milk", amount: 6.08, category: .grocery, paymentType: .visa, date: Date()))
}
