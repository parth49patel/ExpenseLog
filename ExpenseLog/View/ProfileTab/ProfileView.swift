//
//  ProfileView.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-02-27.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query var profile: [ProfileModel]
    @State private var showEditProfileView: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if let userProfile = profile.first {
                    Text("Name: \(userProfile.name)")
                    Text("Email: \(userProfile.email)")
                }

            }
            //.navigationTitle(Text("\(profile.name)"))
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Edit") {
                        showEditProfileView.toggle()
                    }
                }
            }
        }
        .sheet(isPresented: $showEditProfileView) {
            EditProfileView()
        }
    }
}

#Preview {
    ProfileView()
        .modelContainer(for: ProfileModel.self)
}
