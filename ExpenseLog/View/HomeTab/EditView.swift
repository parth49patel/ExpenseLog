//
//  EditView.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-02-05.
//

import SwiftUI

struct EditView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Binding var expense: ExpenseModel
    var userId: String
    
    var body: some View {
        NavigationStack {
                Form {
                    Section {
                        TextField("Title", text: $expense.name)
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
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Edit Expense")
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Button {
                            Task {
                                do {
                                    try await ExpenseManager.shared.saveEditedExpense(userId: userId, expense: expense)
                                    dismiss()
                                    HapticManager.instance.notificationFeedback(type: .success)
                                } catch {
                                    print("Failed to update the expense: \(error.localizedDescription)")
                                }
                            }
                        } label: {
                            Text("Save")
                        }
                        .padding(.bottom)
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                            HapticManager.instance.hapticFeedback(style: .soft)
                        } label: {
                            Text("Cancel")
                        }
                    }
                }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var expense = ExpenseModel(userId: "", name: "Milk", amount: 6.08, category: .grocery, paymentType: .visa, date: Date())
        
        var body: some View {
            EditView(expense: $expense, userId: "demoUser123")
        }
    }
    
    return PreviewWrapper()
}
