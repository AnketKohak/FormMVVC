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
final class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var isEorror: Bool = false
    private let auth = Auth.auth()
    private let fireStore = Firestore.firestore()
    
    init(){
        
    }
    func createUser(email: String, name: String,password: String,contactNumber: String,dateOfBirth: Date) async {
        do{
            let authResult = try await auth.createUser(withEmail: email, password: password)
            await storeUserFirestore(uid: authResult.user.uid, email: email,name: name,contactNumber: contactNumber,dateOfBirth: dateOfBirth)
        }
        catch{
            isEorror = true
        }
    }
    
    func storeUserFirestore(uid: String, email: String, name: String,contactNumber: String,dateOfBirth: Date) async{
        let user = User(uid: uid, email: email, name:name, contactNumber: contactNumber, dateOfBirth: dateOfBirth)
        do{
            try fireStore.collection("users").document(uid).setData(from:user)
        }
        catch{
            isEorror = true

        }
    }
}
