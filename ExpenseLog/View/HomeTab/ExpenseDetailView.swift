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
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Price:")
                            .fontWeight(.regular)
                        Spacer()
                        Text(String(format: "$%.2f", expense.amount))
                            .fontWeight(.bold)
                    }
                    Divider()
                    HStack {
                        Text("Date:")
                            .fontWeight(.regular)
                        Spacer()
                        Text(expense.date, style: .date)
                            .fontWeight(.bold)
                    }
                    Divider()
                    HStack {
                        Text("Category:")
                            .fontWeight(.regular)
                        Spacer()
                        Text(expense.categoryRawValue.capitalized)
                            .fontWeight(.bold)
                    }
                    Divider()
                    HStack {
                        Text("Payment Method:")
                            .fontWeight(.regular)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            
                        Spacer()
                        Text(expense.paymentTypeRawValue.capitalized)
                            .fontWeight(.bold)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                    }
                }
            }
            //.font(.system(size: 25))
            .padding(20)
            .frame(width: 350)
            .background(expense.category.background.gradient.opacity(0.2))
            .clipShape(.rect(cornerRadius: 10))
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    showEditView.toggle()
                } label: {
                    Text("Edit")
                }
            }
            ToolbarItem(placement: .destructiveAction) {
                Button(role: .destructive) {
                    modelContext.delete(expense)
                    try? modelContext.save()
                    dismiss()
                } label: {
                    Label("Delete", systemImage: "trash")
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
    ExpenseDetailView(expense: ExpenseModel(name: "American Eagle", amount: 6.08, category: .clothing, paymentType: .amex, date: Date()))
        .modelContainer(for: ExpenseModel.self)
}
