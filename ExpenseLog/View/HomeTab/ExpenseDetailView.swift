//
//  ExpenseView.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-01-31.
//

import SwiftUI

struct ExpenseDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State var expense: ExpenseModel
    let userId: String
    
    @State private var showEditView: Bool = false
    @State private var deleteAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if colorScheme == .dark {
                    BackgroundView(expenseColor1: expense.category.background, expenseColor2: .black)
                } else {
                    BackgroundView(expenseColor1: expense.category.background, expenseColor2: .white)
                }
                
                VStack {
                    Image(systemName: expense.category.icon)
                        .resizable()
                        .foregroundStyle(
                            Color(expense.category.background)
                        )
                        .frame(width: 200, height: 200)
                        .scaleEffect(x: 0.8, y: 0.8)
                        .shadow(color: colorScheme == .dark ? .black : .white, radius: 10)
                    
                    Text(expense.name)
                        .font(.system(size: 50))
                        .minimumScaleFactor(0.25)
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
                            
                            Spacer()
                            Text(expense.paymentTypeRawValue.capitalized)
                                .fontWeight(.bold)
                        }
                    }
                    .padding(20)
                    .padding(.bottom, 50)
                    
                    // MARK: - Buttons
                    HStack(spacing: 60) {
                        Button {
                            showEditView.toggle()
                        } label: {
                            ButtonView(buttonName: "Edit", symbol: "pencil", textColor: .white, buttonColor: expense.category.background.opacity(0.9))
                        }
                        
                        Button {
                            deleteAlert.toggle()
                            HapticManager().notificationFeedback(type: .warning)
                        } label: {
                            ButtonView(buttonName: "Delete", symbol: "trash", textColor: .white, buttonColor: .red.opacity(0.9))
                        }
                        .alert(isPresented: $deleteAlert) {
                            Alert(title: Text("Delete"),
                                  message: Text("You want to delete this expense?"),
                                  primaryButton: .destructive(Text("Delete"),
                                                               action : {
                                Task {
                                    do {
                                        try await ExpenseManager.shared.deleteExpense(id: expense.id ?? "")
                                        dismiss()
                                        HapticManager.instance.notificationFeedback(type: .success)
                                    } catch {
                                        print("Failed to delete expense: \(error.localizedDescription)")
                                    }
                                }
                            }),
                                  secondaryButton: .cancel())
                        }
                    }
                    Spacer()
                }
                .padding()
                .padding(.bottom)
                .sheet(isPresented: $showEditView) {
                    EditView(expense: $expense, userId: userId)
                }
            }
        }
    }
}

#Preview {
    ExpenseDetailView(expense: ExpenseModel(userId: "", name: "American Eagle", amount: 6.08, category: .clothing, paymentType: .amex, date: Date()), userId: "demoUser123")
}

struct BackgroundView: View {
    @State var expenseColor1: Color
    @State var expenseColor2: Color
    var body: some View {
        LinearGradient(stops: [
            Gradient.Stop(color: expenseColor1.opacity(0.4), location: 0.2),
            Gradient.Stop(color: expenseColor2, location: 0.35),
        ], startPoint: .top, endPoint: .bottom)
        .ignoresSafeArea()
    }
}
