//
//  FirebaseInboxRepository.swift
//  MessageApp
//
//  Created by Lawson Kelly  on 12/7/21.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

class FirebaseInboxRepository: InboxRepository {
    
    var userModels: PassthroughSubject<[String], Never> = PassthroughSubject()
    
    let database = Firestore.firestore()
    let auth = Auth.auth()
    
    var conversationListener: ListenerRegistration?
    
    var currentUsername: String
    
    init(currentUsername: String) {
        self.currentUsername = currentUsername
        observeConversations()
    }
    
    private func observeConversations() {
        conversationListener = database
            .collection("users")
            .document(currentUsername.lowercased())
            .collection("chats").addSnapshotListener { [weak self] snapshot, error in
                guard let usernames = snapshot?.documents.compactMap({ $0.documentID }),
                      error == nil else {
                          return
                      }
                DispatchQueue.main.async {
                    self?.userModels.send(usernames)
                }
            }
    }
    
    func get(completion: @escaping ([String]) -> Void) {
        database.collection("users").getDocuments { snapshot, error in
            guard let usernames = snapshot?.documents.compactMap({ $0.documentID }), error == nil
            else {
                completion([])
                return
            }
            
            DispatchQueue.main.async {
                completion(usernames)
                self.userModels.send(usernames)
            }
        }
    }
    
    func getConversations(completion: @escaping ([String]) -> Void) {
        conversationListener = database
            .collection("users")
            .document(currentUsername.lowercased())
            .collection("chats").addSnapshotListener { [weak self] snapshot, error in
                guard let usernames = snapshot?.documents.compactMap({ $0.documentID }),
                      error == nil else {
                          completion([])
                          return
                      }
                DispatchQueue.main.async {
                    self?.userModels.send(usernames)
                    completion(usernames)
                }
            }
    }
}
