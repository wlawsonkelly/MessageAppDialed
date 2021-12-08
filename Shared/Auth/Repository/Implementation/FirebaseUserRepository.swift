//
//  FirebaseUserRepository.swift
//  MessageApp
//
//  Created by Lawson Kelly  on 12/7/21.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

class FirebaseUserRepository: UserRepository {
    @AppStorage("currentUsername") var currentUsername: String = ""
    @AppStorage("currentEmail") var currentEmail: String = ""
    
    @Published var showSignIn: Bool = true
    
    let database = Firestore.firestore()
    let auth = Auth.auth()
    
    var userModel: PassthroughSubject<User, Never> = PassthroughSubject()
    
    func save(email: String, username: String, password: String) throws {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil,
                    error == nil
            else { return }

            let data = [
                "email": email,
                "username": username
            ]

            self?.database.collection("users").document(username).setData(data) {
                err in
                guard err == nil else { return }
            }

            DispatchQueue.main.async {
                self?.currentEmail = email
                self?.currentUsername = username
                self?.showSignIn = false
                self?.userModel.send(User(email: email, username: username))
            }
        }
    }
    
    func get(username: String, password: String) throws {
        database.collection("users").document(username.lowercased()).getDocument { [weak self] snapshot, error in
            print("there")
            guard let email = snapshot?.data()?["email"] as? String, error == nil else { return }
            print("here")
            self?.auth.signIn(withEmail: email, password: password, completion: { result, error in
                guard result != nil, error == nil else { return }

                DispatchQueue.main.async {
                    self?.currentEmail = email
                    self?.currentUsername = username
                    self?.showSignIn = false
                    self?.userModel.send(User(email: email, username: username))
                }
            })
        }
    }
}
