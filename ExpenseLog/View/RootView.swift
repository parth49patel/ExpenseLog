//
//  RootView.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-04-11.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    var body: some View {
        ZStack {
            if userViewModel.isUserAuthenticated {
                ContentView()
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            } else {
                SignInOptionView()
                    .transition(.move(edge: .leading).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: userViewModel.isUserAuthenticated)
    }
}

#Preview {
    RootView()
        .environmentObject(UserViewModel.shared)
}
