//
//  ContentView.swift
//  FormMVVC
//
//  Created by anket kohak on 14/11/24.
//Anket

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = FormViewModel() // ViewModel instance
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    // Name
                    HStack {
                        TextField("Name", text: $viewModel.formData.name)
                            .textContentType(.name)
                            .autocapitalization(.words)
                        
                        ErrorText(message: viewModel.errorMessages.first(where: { $0.contains("Name") }) ?? "")
                    }
                    
                    // Email
                    HStack {
                        TextField("Email", text: $viewModel.formData.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .textContentType(.emailAddress)
                        
                        ErrorText(message: viewModel.errorMessages.first(where: { $0.contains("Email") }) ?? "")
                    }
                    
                    // Contact Number
                    HStack {
                        TextField("Contact Number", text: $viewModel.formData.contactNumber)
                            .keyboardType(.phonePad)
                            .textContentType(.telephoneNumber)
                        
                        ErrorText(message: viewModel.errorMessages.first(where: { $0.contains("number") }) ?? "")
                    }
                    
                    // Date of Birth
                    DatePicker("Date of Birth", selection: $viewModel.formData.dateOfBirth, displayedComponents: .date)
                        .onChange(of: viewModel.formData.dateOfBirth) { _ in }
                    
                    ErrorText(message: viewModel.errorMessages.first(where: { $0.contains("years") }) ?? "")
                }
                
                Section(header: Text("Security")) {
                    // Password
                    HStack {
                        SecureField("Password", text: $viewModel.formData.password)
                            .textContentType(.password)
                        
                        ErrorText(message: viewModel.errorMessages.first(where: { $0.contains("Password") }) ?? "")
                    }
                }
                
                // Submit Button
                Button(action: viewModel.submitForm) {
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
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationTitle("User Registration")
        }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
