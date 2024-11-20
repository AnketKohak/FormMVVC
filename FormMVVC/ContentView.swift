//
//  ContentView.swift
//  FormMVVC
//
//  Created by anket kohak on 14/11/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AuthFormViewModel()
    @State private var confirmPassword: String = ""
    
    var isValid: Bool {
        !viewModel.formData.password.isEmpty &&
        !confirmPassword.isEmpty &&
        viewModel.formData.password == confirmPassword
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    // Name
                    HStack {
                        TextField("Name", text: $viewModel.formData.name)
                            .textContentType(.name)
                            .autocapitalization(.words)
                            .onChange(of: viewModel.formData.name) { _ in
                                removeError(for: "Name")
                            }
                        
                        ErrorText(message: viewModel.errorMessages.first(where: { $0.contains("Name") }) ?? "")
                    }
                    
                    // Email
                    HStack {
                        TextField("Email", text: $viewModel.formData.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .textContentType(.emailAddress)
                            .onChange(of: viewModel.formData.email) { _ in
                                removeError(for: "Email")
                            }
                        
                        ErrorText(message: viewModel.errorMessages.first(where: { $0.contains("Email") }) ?? "")
                    }
                    
                    // Contact Number
                    HStack {
                        TextField("Contact Number", text: $viewModel.formData.contactNumber)
                            .keyboardType(.phonePad)
                            .textContentType(.telephoneNumber)
                            .onChange(of: viewModel.formData.contactNumber) { _ in
                                removeError(for: "number")
                            }
                        
                        ErrorText(message: viewModel.errorMessages.first(where: { $0.contains("number") }) ?? "")
                    }
                    
                    // Date of Birth
                    DatePicker("Date of Birth", selection: $viewModel.formData.dateOfBirth, displayedComponents: .date)
                        .onChange(of: viewModel.formData.dateOfBirth) { _ in
                            removeError(for: "years")
                        }
                    
                    ErrorText(message: viewModel.errorMessages.first(where: { $0.contains("years") }) ?? "")
                }
                
                Section(header: Text("Security")) {
                    // Password
                    HStack {
                        SecureField("Password", text: $viewModel.formData.password)
                            .textContentType(.password)
                            .onChange(of: viewModel.formData.password) { _ in
                                removeError(for: "Password")
                            }
                        
                        ErrorText(message: viewModel.errorMessages.first(where: { $0.contains("Password") }) ?? "")
                    }
                    
                    // Confirm Password
                    ZStack(alignment: .trailing) {
                        InputView(placeholder: "Confirm Your Password", isSecureField: true, text: $confirmPassword)
                            .onChange(of: confirmPassword) { _ in
                                // Remove alert message if passwords are now matching
                                if isValid {
                                    viewModel.alertMessage = ""
                                    viewModel.isError = false
                                }
                            }
                        
                        Spacer()
                        
                        if !viewModel.formData.password.isEmpty && !confirmPassword.isEmpty {
                            Image(systemName: "\(isValid ? "checkmark" : "xmark").circle.fill")
                                .imageScale(.large)
                                .foregroundStyle(isValid ? .green : .red)
                        }
                    }
                }
                
                // Submit Button
                Button {
                    viewModel.submitForm() // Validate form first
                    if viewModel.errorMessages.isEmpty {
                        Task {
                            await viewModel.createUser(
                                email: viewModel.formData.email,
                                name: viewModel.formData.name,
                                password: viewModel.formData.password,
                                contactNumber: viewModel.formData.contactNumber,
                                dateOfBirth: viewModel.formData.dateOfBirth
                            )
                        }
                    }
                } label: {
                    Text(viewModel.isLoading ? "Submitting..." : "Submit")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .background(viewModel.isLoading ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .disabled(viewModel.isLoading)
                }
                
                // Alert
                if !viewModel.alertMessage.isEmpty {
                    Text(viewModel.alertMessage)
                        .foregroundColor(viewModel.isError ? .red : .green)
                        .padding()
                }
            }
            .navigationTitle("User Registration")
        }
    }
    
  
    private func removeError(for field: String) {
        viewModel.errorMessages.removeAll { $0.contains(field) }
    }
}

struct ErrorText: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.caption2)
            .foregroundColor(.red)
            .frame(height: 15)
            .opacity(message.isEmpty ? 0 : 1)
    }
}

// MARK: InputView for Secure Fields
struct InputView: View {
    let placeholder: String
    let isSecureField: Bool
    @Binding var text: String
    
    var body: some View {
        if isSecureField {
            SecureField(placeholder, text: $text)
                .textContentType(.password)
        } else {
            TextField(placeholder, text: $text)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
