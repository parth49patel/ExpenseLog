//
//  ExpenseView.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-01-31.
//

import SwiftUI
import SwiftData

struct ExpenseDetailView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query var expenses: [ExpenseModel]
    let expense: ExpenseModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
                Image(systemName: expense.category.icon)
                    .resizable()
                    .foregroundStyle(
                        LinearGradient(
                            stops: [Gradient.Stop(color: expense.category.background, location: 0.5), Gradient.Stop(color: .black, location: 1)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 300, height: 300)
                    .scaleEffect(x: 0.8, y: 0.8)
            
            VStack {
                Text(expense.name)
                    .font(.system(size: 50))
                    .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Price:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(String(format: "$%.2f", expense.amount))
                    }
                    HStack {
                        Text("Date:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(expense.date, style: .date)
                    }
                    HStack {
                        Text("Category:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(expense.categoryRawValue.capitalized)
                    }
                }
            }
            .font(.system(size: 25))
            .padding(20)
            .frame(width: 350)
            .background(.gray.opacity(0.3))
            .clipShape(.rect(cornerRadius: 10))
        }
        Button {
            modelContext.delete(expense)
            try? modelContext.save()
            dismiss()
        } label: {
            DeleteButton(buttonName: "Delete", backgroundColor: .red, textColor: .white)
                .textCase(.uppercase)
        }
    }
}

#Preview {
    ExpenseDetailView(expense: ExpenseModel(name: "Milk", amount: 6.08, category: .food, paymentType: .visa, date: Date()))
        .modelContainer(for: ExpenseModel.self)
}
