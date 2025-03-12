//
//  AddExpenseView.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-01-29.
//

import SwiftUI
import SwiftData

struct AddExpenseView: View {
    
    @State var name: String = ""
    @State var note: String? = nil
    @State var amount: Double = 0
    @State var date: Date = .now
    @State var category: ExpenseCategory = .other
    @State var paymentType: PaymentType = .cash
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var expenses: [ExpenseModel]
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        TextField("Title", text: $name)
                            .scrollDismissesKeyboard(.immediately)
                        TextField("Add a note here...", text:
                                    Binding(get: { note ?? ""},
                                            set: { note = $0.isEmpty ? nil : $0}))
                        .scrollDismissesKeyboard(.interactively)
                    }
                    Section {
                        HStack {
                            Text("Amount: ")
                            TextField("", value: $amount, format: .number)
                                .keyboardType(.decimalPad)
                                .scrollDismissesKeyboard(.immediately)
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
            }
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveExpense()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    private func saveExpense() {
        let newExpense = ExpenseModel(name: name, amount: amount, category: category, paymentType: paymentType, date: date)
        modelContext.insert(newExpense)
    }
}

#Preview {
        AddExpenseView()
            .modelContainer(for: ExpenseModel.self)
    
    
}
