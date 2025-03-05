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
                    Image(systemName: "list.bullet.rectangle.fill")
                    Text("Expenses")
                }
            SummaryView()
                .tabItem {
                    Image(systemName: "dollarsign.gauge.chart.lefthalf.righthalf")
                    Text("Summary")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ExpenseModel.self)
}
