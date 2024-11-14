//
//  FormData.swift
//  FormMVVC
//
//  Created by anket kohak on 14/11/24.
//

import Foundation
// Form data model
struct FormData {
    var name: String = ""
    var email: String = ""
    var contactNumber: String = ""
    var dateOfBirth: Date = Date()
    var password: String = ""
    
    // Validate form fields
    func validate() -> [String] {
        var messages: [String] = []
        
        // Name Validation
        if name.isEmpty {
            messages.append("Name is required")
        }
        
        // Email Validation
        if email.isEmpty {
            messages.append("Email is required")
        } else if !isValidEmail(email) {
            messages.append("Enter a valid Email address.")
        }
        
        // Contact number validation
        if contactNumber.count != 10 || !contactNumber.allSatisfy({ $0.isNumber }) {
            messages.append("10-digit number required")
        }
        
        // Age validation (user must be older than 4 years)
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: Date())
        if let age = ageComponents.year, age < 4 {
            messages.append("You must be older than 4 years.")
        }
        
        // Password Validation
        if password.isEmpty {
            messages.append("Password is required.")
        } else if password.count < 8 {
            messages.append("Password must be at least 8 characters.")
        }
        
        return messages
    }
    
    // Email regex validation
    private func isValidEmail(_ email: String) -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailPattern)
        return emailPredicate.evaluate(with: email)
    }
}
