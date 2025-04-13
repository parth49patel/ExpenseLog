//
//  HapticManager.swift
//  ExpenseLog
//
//  Created by Parth Patel on 2025-03-27.
//

import SwiftUI

class HapticManager {
    
    static let instance = HapticManager()
    
    func hapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    func notificationFeedback(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}
