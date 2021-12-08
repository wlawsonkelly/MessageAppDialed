//
//  FirebaseMessageRepository.swift
//  MessageApp
//
//  Created by Lawson Kelly  on 12/7/21.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

class FirebaseMessageRepository: MessageRepository {
    var messageModels: PassthroughSubject<[Message], Never> = PassthroughSubject()
    
    var chatListener: ListenerRegistration?
    
    let database = Firestore.firestore()
    let auth = Auth.auth()
    
    var currentUsername: String
    var otherUsername: String
    
    init(currentUsername: String, otherUsername: String) {
        self.currentUsername = currentUsername
        self.otherUsername = otherUsername
        observeChanges()
    }
    
    func save(text: String) throws {
        let newMessageId = UUID().uuidString
        let dateString = ISO8601DateFormatter().string(from: Date())
        
        guard !dateString.isEmpty,
              !otherUsername.isEmpty,
              !text.isEmpty
        else {
            throw MessageRepositoryError.invalidData
        }
        
        let data = [
            "text": text,
            "sender": currentUsername.lowercased(),
            "created": dateString
        ]
        
        database.collection("users")
            .document(currentUsername.lowercased())
            .collection("chats")
            .document(otherUsername).setData(["created":"true"])
        
        database.collection("users")
            .document(otherUsername)
            .collection("chats")
            .document(currentUsername.lowercased()).setData(["created":"true"])
        
        database.collection("users")
            .document(currentUsername.lowercased())
            .collection("chats")
            .document(otherUsername)
            .collection("messages")
            .document(newMessageId)
            .setData(data)
        
        database.collection("users")
            .document(otherUsername)
            .collection("chats")
            .document(currentUsername.lowercased())
            .collection("messages")
            .document(newMessageId)
            .setData(data)
    }
    
    private func observeChanges() {
        guard otherUsername != "" else { return }
        chatListener = database
            .collection("users")
            .document(currentUsername.lowercased())
            .collection("chats")
            .document(otherUsername)
            .collection("messages")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let objects = snapshot?.documents.compactMap({ $0.data() }),
                      error == nil else {
                          return
                      }
                
                let messages: [Message] = objects.compactMap({
                    guard let date = ISO8601DateFormatter().date(from: $0["created"] as? String ?? "") else {
                        return nil
                    }
                    return Message(
                        text: $0["text"] as? String ?? "",
                        type: $0["sender"] as? String == self?.currentUsername ? .sent : .received,
                        created: date
                    )
                }).sorted(by: { first, second in
                    return first.created < second.created
                })
                
                DispatchQueue.main.async {
                    self?.messageModels.send(messages)
                }
            }
    }
}
