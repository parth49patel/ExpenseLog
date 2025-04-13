//
//  SignInOptionsButton.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-03-29.
//

import SwiftUI

struct SignInOptionsButton: View {
    
    @State var buttonName: String
    @State var buttonImage: String
    @State var textColor: Color
    @State var buttonColor: Color
    
    var body: some View {
        VStack {
            HStack {
                Text(buttonName)
                Image(systemName: buttonImage)
            }
            .foregroundStyle(textColor)
            .font(.system(size: 20, weight: .semibold, design: .default))
            .frame(maxWidth: UIScreen.main.bounds.width)
            .padding()
            .background(buttonColor)
            .clipShape(.rect(cornerRadius: 10))
        }
    }
}

#Preview {
    SignInOptionsButton(buttonName: "Sign in with Email", buttonImage: "envelope.badge.person.crop.fill", textColor: .white, buttonColor: .blue)
}
