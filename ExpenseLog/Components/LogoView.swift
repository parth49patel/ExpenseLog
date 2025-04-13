//
//  LogoView.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-03-26.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        VStack {
            Image("LoginView")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .clipShape(.rect(cornerRadius: 10))
            Text("Expense Log")
                .font(.system(size: 25, weight: .medium, design: .serif))
        }
    }
}

#Preview {
    LogoView()
}
