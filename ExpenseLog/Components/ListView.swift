//
//  ListView.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-03-03.
//

import SwiftUI
import SwiftData

struct ListView: View {
    
    let expense: ExpenseModel
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(expense.name)
                    .font(.system(size: 25, weight: .medium))
                    .minimumScaleFactor(0.25)
                    .lineLimit(1)
                HStack(spacing: 10) {
                    Image(systemName: expense.category.icon)
                        .foregroundStyle(expense.category.background)
                    Text(expense.paymentTypeRawValue.capitalized)
                        .font(.system(size: 15, weight: .light))
                }
            }
            Spacer(minLength: 30)
            Text("$\(String(format: "%.2f", expense.amount))")
                .font(.system(size: 25, weight: .medium))
        }
        .fontDesign(.rounded)
        .padding()
        .background(
            Color(expense.category.background.opacity(0.2))
        )
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    ListView(expense: ExpenseModel(name: "Yeh Jawaani Hai Deewani", amount: 49.28, note: "", category: .entertainment, paymentType: .amex, date: .now))
}
