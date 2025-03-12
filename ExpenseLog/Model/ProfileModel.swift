//
//  ProfileModel.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-03-04.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class ProfileModel {
    
    static let sharedID = "ProfileModel"
    
    var id: String = ProfileModel.sharedID
    var name : String
    var dob : Date
    var email : String
    var profileImage : Data?
    
    init(name: String, dob: Date, email: String, profileImage: Data? = nil) {
        self.name = name
        self.dob = dob
        self.email = email
        self.profileImage = profileImage
    }
}
