//
//  DeleteButton.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-02-04.
//

import SwiftUI

struct DeleteButton: View {
    
    @State var buttonName: String
    @State var backgroundColor: Color
    @State var textColor: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .frame(width: 160, height: 60)
            .foregroundStyle(backgroundColor.gradient)
            .overlay {
                Text(buttonName)
                    .foregroundStyle(textColor)
                    .font(.system(size: 25, weight: .semibold, design: .rounded))
            }
    }
}

#Preview {
    DeleteButton(buttonName: "Delete", backgroundColor: .red, textColor: .white)
}
