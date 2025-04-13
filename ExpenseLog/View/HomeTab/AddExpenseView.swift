//
//  AddExpenseView.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-01-29.
//

import SwiftUI
import FirebaseAuth

struct AddExpenseView: View {
    
    @State var name: String = ""
    @State var amount: String = ""
    @State var date: Date = .now
    
    @State var category: ExpenseCategory = .other
    @State var paymentType: PaymentType = .cash
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        TextField("Title", text: $name)
                    }
                    Section {
                        HStack {
                            Text("Amount: ")
                            TextField("0.00", text: $amount)
                                .keyboardType(.decimalPad)
                                .onChange(of: amount) { _, newValue in
                                    let filtered = newValue.filter { "0123456789.".contains($0) }
                                    let components = filtered.split(separator: ".")
                                    if components.count == 2 {
                                        let decimal = components[1].prefix(2)
                                        amount = "\(components[0]).\(decimal)"
                                    } else {
                                        amount = filtered
                                    }
                                }
                                
                        }
                    }
                    Section {
                        HStack {
                            DatePicker("Expense Date", selection: $date, in: ...Date.now, displayedComponents: .date)
                                .datePickerStyle(.compact)
                        }
                    }
                    Section {
                        Picker("Category", selection: $category) {
                            ForEach(ExpenseCategory.allCases, id: \.self) { category in
                                Label(category.rawValue.capitalized, systemImage: category.icon)
                            }
                        }
                        Picker("Payment Type", selection: $paymentType) {
                            ForEach(PaymentType.allCases, id: \.self) { paymentType in
                                Text(paymentType.rawValue.capitalized)
                            }
                        }
                    }
                }
                .navigationTitle("Add Expense")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            Task {
                                do {
                                    try await saveExpense()
                                } catch {
                                    print("Error saving expense: \(error.localizedDescription)")
                                }
                            }
                        }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || !(Double(amount) ?? 0 > 0))
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
    private func saveExpense() async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in!")
            return
        }
        guard let amountValue = Double(amount), amountValue > 0 else {
            return
        }
        let expense = ExpenseModel(
            userId: userId,
            name: name,
            amount: amountValue,
            category: category,
            paymentType: paymentType,
            date: date)
        
        try await ExpenseManager.shared.createExpense(userId: userId, expense: expense)
        
        dismiss()
        HapticManager.instance.notificationFeedback(type: .success)
    }
}

#Preview {
    AddExpenseView()
}
