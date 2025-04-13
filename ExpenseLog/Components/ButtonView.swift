//
//  Button.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-03-14.
//

import SwiftUI

struct ButtonView: View {
    
    @State var buttonName: String
    @State var symbol: String
    @State var textColor: Color
    @State var buttonColor: Color
    
    var body: some View {
        HStack {
            Text(buttonName)
            Image(systemName: symbol)
        }
        .frame(width: 100, height: 30)
        .font(.system(size: 20, weight: .bold))
        .foregroundStyle(textColor)
        .padding()
        .background(buttonColor)
        .clipShape(.rect(cornerRadius: 10))
        .shadow(radius: 10)
    }
}

#Preview {
    ButtonView(buttonName: "Delete", symbol: "trash", textColor: .white, buttonColor: .red)
}
