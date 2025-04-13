//
//  ContentView.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-01-25.
//

import SwiftUI
import FirebaseFirestore

struct HomeView: View {
    
    @StateObject private var expenseManager = ExpenseManager.shared
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var isLoggedOut: Bool = false
    @State private var filterByPayment: PaymentType? = nil
    @State private var filterByCategory: ExpenseCategory? = nil
    @State private var showAddExpenseView: Bool = false
    @State private var accountDeleteAlertIsPresented: Bool = false
    
    let userId: String
    
    private var filteredExpenses: [ExpenseModel] {
        expenseManager.expenses.filter { expense in
            let matchesPayment = filterByPayment == nil || expense.paymentType == filterByPayment
            let matchesCategory = filterByCategory == nil || expense.category == filterByCategory
            return matchesPayment && matchesCategory
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(filteredExpenses) { expense in
                        NavigationLink(destination: ExpenseDetailView(expense: expense, userId: userId)) {
                            ListView(expense: expense)
                                .padding(.horizontal, 10)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .onAppear {
                Task {
                    await expenseManager.loadExpenses(for: userId)
                }
            }
            .navigationBarTitle("Expenses")
            
            // MARK: - Toolbar
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddExpenseView.toggle()
                        HapticManager.instance.hapticFeedback(style: .light)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("", systemImage: "gear") {
                        Button {
                            Task {
                                do {
                                    try userViewModel.signOut()
                                    isLoggedOut = true
                                } catch {
                                    print(error)
                                }
                            }
                        } label: {
                            Text("Log Out")
                                .foregroundStyle(.blue)
                        }
                        Button{
                            accountDeleteAlertIsPresented = true
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Menu("Filter by Payment Type") {
                            Picker("Payment Type", selection: $filterByPayment) {
                                Text("All").tag(nil as PaymentType?)
                                ForEach(PaymentType.allCases, id: \.self) { paymentType in
                                    Text(paymentType.rawValue.capitalized).tag(paymentType as PaymentType?)
                                }
                            }
                        }
                        
                        Menu("Filter by Category") {
                            Picker("Category", selection: $filterByCategory) {
                                Text("All").tag(nil as ExpenseCategory?)
                                ForEach(ExpenseCategory.allCases, id: \.self) { category in
                                    Text(category.rawValue.capitalized)
                                        .tag(category as ExpenseCategory?)
                                }
                            }
                        }
                        
                        Button("Clear Filters", role: .destructive) {
                            filterByPayment = nil
                            filterByCategory = nil
                            HapticManager.instance.hapticFeedback(style: .heavy)
                        }
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease")
                    }
                }
            }
            
            // MARK: - Sheets and Confirmation Dialog
            .confirmationDialog("Deleting account will delete all the expenses. Are you sure you want to delete your account?", isPresented: $accountDeleteAlertIsPresented, titleVisibility: .visible) {
                Button("Delet Account", role: .destructive) {
                    Task {
                        do {
                            try await userViewModel.deleteUser()
                            isLoggedOut = true
                        } catch {
                            print(error)
                        }
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
            .fullScreenCover(isPresented: $isLoggedOut) {
                SignInOptionView()
            }
            .sheet(isPresented: $showAddExpenseView, onDismiss: {
                Task {
                    await expenseManager.loadExpenses(for: userId)
                }
            }) {
                AddExpenseView()
                    .presentationBackgroundInteraction(.disabled)
                    .presentationContentInteraction(.scrolls)
                    .interactiveDismissDisabled(true)
            }
        }
    }
}

#Preview {
    HomeView(userId: "demoUser123")
}

