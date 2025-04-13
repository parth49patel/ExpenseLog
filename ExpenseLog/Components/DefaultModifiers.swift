//
//  DefaultModifiers.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-03-26.
//

import SwiftUI

struct DefaultModifiers: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    DefaultModifiers()
}

struct TextModidier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .fontWeight(.semibold)
            .font(.title2)
    }
}

struct TextFieldModidier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(height: 40)
            .background()
            .clipShape(.rect(cornerRadius: 5))
            .padding(.bottom, 20)
    }
}
