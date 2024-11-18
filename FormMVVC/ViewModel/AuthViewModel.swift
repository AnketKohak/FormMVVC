//
//  AuthViewModel.swift
//  FormMVVC
//
//  Created by anket kohak on 18/11/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var isEorror: Bool = false
    private let auth = Auth.auth()
    private let fireStore = Firestore.firestore()
    
    init(){
        
    }
    func createUser(email: String, fullName: String,password: String) async {
        do{
            let authResult = try await auth.createUser(withEmail: email, password: password)
            await storeUserFirestore(uid: authResult.user.uid, email: email,fullName: fullName)
        }
        catch{
            isEorror = true
        }
    }
    
    func storeUserFirestore(uid: String, email: String, fullName: String) async{
        let user = User(uid: uid, email: email, fullName: fullName)
        do{
            try fireStore.collection("users").document(uid).setData(from:user)
        }
        catch{
            
        }
    }
}
