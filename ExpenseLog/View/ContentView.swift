//
//  TabView.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-02-27.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "dollarsign.circle.fill")
                    Text("Expenses")
                }
            SummaryView()
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Summary")
                }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ExpenseModel.self)
}
