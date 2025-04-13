//
//  SignInOptionView.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-03-29.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth

struct SignInOptionView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(stops: [
                    Gradient.Stop(color: .gray.opacity(0.2), location: 0.2),
                    Gradient.Stop(color: .gray.opacity(0.6), location: 0.6),
                ], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                
                VStack {
                    LogoView()
                        .padding(.top, 50)
                    
                    VStack(spacing: 20) {
                        GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                            Task {
                                do {
                                    try await userViewModel.signInGoogle()
                                } catch {
                                    print(error)
                                }
                            }
                        }
                        Button {
                            Task {
                                do {
                                    try await userViewModel.signInApple()
                                } catch {
                                    print(error)
                                }
                            }
                        } label: {
                            SignInWithAppleButtonViewRepresentable(type: .default, style: .black)
                                .allowsHitTesting(false)
                        }
                        .frame(height: 55)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 100)
                }
            }
        }
    }
    
}

#Preview {
    SignInOptionView()
}
