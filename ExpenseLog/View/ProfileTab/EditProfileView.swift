//
//  EditProfileView.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-03-04.
//

import SwiftUI
import SwiftData

struct EditProfileView: View {
    
    @State var name: String = ""
    @State var dob: Date = Date()
    @State var email: String = ""
    @State var profileImage: Data? = nil
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Query var profile: [ProfileModel]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Personal Info") {
                    TextField("Full Name", text: $name)
                    DatePicker("Date of Birth", selection: $dob, displayedComponents: .date)
                }
                Section("Profile Picture") {
                    
                }
                Section("Contact Info") {
                    TextField("Email Address", text: $email)
                }
            }
            .navigationTitle(Text("Edit Profile"))
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        saveProfile()
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
    }
    private func saveProfile() {
        let newProfile = ProfileModel(name: name, dob: dob, email: email, profileImage: profileImage)
        modelContext.insert(newProfile)
    }
}

#Preview {
    EditProfileView()
}
