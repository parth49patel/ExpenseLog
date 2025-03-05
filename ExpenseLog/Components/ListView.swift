//
//  ListView.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-03-03.
//

import SwiftUI
import SwiftData

struct ListView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        HStack {
            
        }
    }
}

#Preview {
    ListView()
        .modelContainer(for: ExpenseModel.self)
}
