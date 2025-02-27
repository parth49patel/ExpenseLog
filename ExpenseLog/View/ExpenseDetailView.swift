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
    @Environment(\.dismiss) var dismiss
    
    @Query var expenses: [ExpenseModel]
    let expense: ExpenseModel
    
    @State private var showEditView: Bool = false
    
    var body: some View {
        ScrollView {
            Image(systemName: expense.category.icon)
                .resizable()
                .foregroundStyle(
                    LinearGradient(
                        stops: [Gradient.Stop(color: expense.category.background, location: 0.5), Gradient.Stop(color: .gray, location: 1)],
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
                            .fontWeight(.medium)
                        Spacer()
                        Text(String(format: "$%.2f", expense.amount))
                    }
                    Divider()
                    HStack {
                        Text("Date:")
                            .fontWeight(.medium)
                        Spacer()
                        Text(expense.date, style: .date)
                    }
                    Divider()
                    HStack {
                        Text("Category:")
                            .fontWeight(.medium)
                        Spacer()
                        Text(expense.categoryRawValue.capitalized)
                    }
                    Divider()
                    HStack {
                        Text("Payment Method:")
                            .fontWeight(.medium)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        Spacer()
                        Text(expense.paymentTypeRawValue.capitalized)
                    }
                }
            }
            .font(.system(size: 25))
            .padding(20)
            .frame(width: 350)
            .background(expense.category.background.gradient.opacity(0.2))
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
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    showEditView.toggle()
                } label: {
                    Text("Edit")
                }
            }
        }
        .padding(.bottom)
        .sheet(isPresented: $showEditView) {
            EditView(expense: expense)
        }
    }
}

#Preview {
    ExpenseDetailView(expense: ExpenseModel(name: "Milk", amount: 6.08, category: .food, paymentType: .visa, date: Date()))
        .modelContainer(for: ExpenseModel.self)
}
