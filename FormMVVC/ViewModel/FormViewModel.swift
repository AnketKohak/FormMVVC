//
//  FormViewModel.swift
//  FormMVVC
//
//  Created by anket kohak on 14/11/24.
//

import Foundation
import SwiftUI

class FormViewModel: ObservableObject {
    @Published var formData = FormData() // This will hold the form data
    @Published var errorMessages: [String] = [] // To display validation errors
    @Published var alertMessage: String = "" // To display alert messages
    @Published var isLoading: Bool = false // Show loading state
    
    // Submit Form Data to API
    func submitForm() {
        // Validate the form
        errorMessages = formData.validate()
        
        if errorMessages.isEmpty {
            // Send data to API
            sendFormDataToAPI()
        } else {
            alertMessage = "Please correct the errors in the form."
        }
    }
    
    // API submission logic (mock)
    private func sendFormDataToAPI() {
        // Mocking a network request
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            self.alertMessage = "Form submitted successfully!"
        }
    }
}
