//
//  ListView.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-03-03.
//

import SwiftUI

struct ListView: View {
    
    let expense: ExpenseModel
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(expense.name)
                    .font(.system(size: 25, weight: .medium))
                    .frame(maxWidth: 200, alignment: .leading)
                    .lineLimit(1)
                    .truncationMode(.tail)
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
        .padding(15)
        .background(
//            LinearGradient(stops: [
//                Gradient.Stop(color: expense.category.background.opacity(0.4), location: 0.1),
//                Gradient.Stop(color: expense.category.background.opacity(0.2), location: 0.3),
//                Gradient.Stop(color: .clear, location: 0.6)
//            ], startPoint: .top, endPoint: .bottom)
            Color(expense.category.background.opacity(0.2))
        )
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    ListView(expense: ExpenseModel(userId: "123", name: "Yeh Jawaani Hai Deewani Yeh Jawaani Hai Deewani", amount: 49.28, category: .entertainment, paymentType: .amex, date: .now))
}
