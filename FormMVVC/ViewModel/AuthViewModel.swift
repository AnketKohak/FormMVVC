//
//  AuthViewModel.swift
//  FormMVVC
//
//  Created by anket kohak on 18/11/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
@MainActor
final class AuthFormViewModel: ObservableObject {
   
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var isError: Bool = false
    private let auth = Auth.auth()
    private let fireStore = Firestore.firestore()
    
    // Form properties
    @Published var formData = FormData()
    @Published var errorMessages: [String] = []
    @Published var alertMessage: String = ""
    @Published var isLoading: Bool = false
    
    init() {}
    
    // Create User with Authentication and Firestore Storage
    func createUser(email: String, name: String, password: String, contactNumber: String, dateOfBirth: Date) async {
        do {
            isLoading = true
            let authResult = try await auth.createUser(withEmail: email, password: password)
            await storeUserFirestore(uid: authResult.user.uid, email: email, name: name, contactNumber: contactNumber, dateOfBirth: dateOfBirth)
            
          
            if !isError {
            }
        } catch {
            isError = true
            alertMessage = "Failed to Store. Please try again."
        }
        isLoading = false
    }
    
    // Store user data in Firestore
    func storeUserFirestore(uid: String, email: String, name: String, contactNumber: String, dateOfBirth: Date) async {
        let user = User(uid: uid, email: email, name: name, contactNumber: contactNumber, dateOfBirth: dateOfBirth)
        do {
            try fireStore.collection("users").document(uid).setData(from: user)
        } catch {
            isError = true
            
        }
    }
    
    // Submit Form Data to API
    func submitForm() {
        
        errorMessages = formData.validate()
        
        if errorMessages.isEmpty {
            Task {
                await createUser(
                    email: formData.email,
                    name: formData.name,
                    password: formData.password,
                    contactNumber: formData.contactNumber,
                    dateOfBirth: formData.dateOfBirth
                )
                
               
                if !isError {
                    alertMessage = "Form submitted successfully!"
                }
            }
        } else {
            
        }
    }
}
