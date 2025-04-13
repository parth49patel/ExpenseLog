//
//  AuthenticationManager.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-03-29.
//

import Foundation
import FirebaseAuth
import AuthenticationServices
import FirebaseFirestore

struct AuthDataResultModel: Equatable {
    let uid: String
    let name: String?
    let email: String?
    let photoUrl: String?
    let isAnonymous: Bool
    
    init(user: User) {
        self.uid = user.uid
        self.name = user.displayName
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        self.isAnonymous = user.isAnonymous
    }
    // Conform to Equatable by implementing the == operator
    static func ==(lhs: AuthDataResultModel, rhs: AuthDataResultModel) -> Bool {
        return lhs.uid == rhs.uid
    }
    
}

@MainActor
final class UserViewModel: ObservableObject {
    
    static let shared = UserViewModel()
    init() {
        self.isUserAuthenticated = Auth.auth().currentUser != nil
        print("User is \(isUserAuthenticated ? "" : "not ")authenticated on launch")
    }
    
    @Published var currentUser: AuthDataResultModel?
    @Published var user: DBUser? = nil
    @Published var isUserAuthenticated: Bool = false // Add this here to track authentication
     
    // MARK: - Get Authenticated User
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    
    // MARK: - Sign Out
    func signOut() throws {
        try Auth.auth().signOut()
        self.currentUser = nil
        self.user = nil
        self.isUserAuthenticated = false // Update authentication state
    }
    
    // MARK: - Delete User
    func deleteUser() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        
        let userId = user.uid
        let db = Firestore.firestore()
        
        let expenses = try await ExpenseManager.shared.fetchExpenses(for: userId)
        
        let batch = db.batch()
        
        for expense in expenses {
            if let expenseId = expense.id {
                let expenseRef = db.collection("expenses").document(expenseId)
                batch.deleteDocument(expenseRef)
                //try await ExpenseManager.shared.deleteExpense(id: expenseId)
            }
        }
        let userRef = db.collection("users").document(userId)
        batch.deleteDocument(userRef)
        try await batch.commit()
        try await user.delete()
        
        self.currentUser = nil
        self.user = nil
        self.isUserAuthenticated = false
    }
    
    // MARK: - Load Current User
    func loadCurrentUser() async throws {
        guard let authDataResult = try? getAuthenticatedUser() else {
            currentUser = nil
            self.isUserAuthenticated = false // Update authentication state
            return
        }
        self.currentUser = authDataResult
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
        self.isUserAuthenticated = true /// Update authentication state, this is where the mistake was
    }
}

// MARK: - SIGN IN
extension UserViewModel {
    
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    @discardableResult
    func signInWithApple(tokens: SignInWithAppleResult) async throws -> AuthDataResultModel {
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokens.token, rawNonce: tokens.nonce)
        return try await signIn(credential: credential)
    }
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
}

// MARK: - Apple Sign In
extension UserViewModel {
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await signInWithApple(tokens: tokens)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
        self.isUserAuthenticated = true
        try await loadCurrentUser()
    }
}

// MARK: - Google Sign In
extension UserViewModel {
        func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await signInWithGoogle(tokens: tokens)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
        self.isUserAuthenticated = true
        try await loadCurrentUser()
    }
}

