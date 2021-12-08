//
//  AppStateModel.swift
//  TestMessaging
//
//  Created by Lawson Kelly  on 12/1/21.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class AppState: ObservableObject {
    @AppStorage("currentUsername") var currentUsername: String = ""
    @AppStorage("currentEmail") var currentEmail: String = ""

    @Published var conversations: [String] = []
    @Published var showSignIn: Bool = true
    @Published var messages: [Message] = []
    
    @Published var composeText: String = "Write something!"
    var quickReplyPosition: Int = 0
    @Published var quickReplySuggestion: String = ""
    
    @Published var quickReplies: [String] = [
        "Sure that works",
        "No problem",
        "I'm on it"
    ]
    
    @Published var recipientField: String = ""

    var otherUsername: String = ""

    let database = Firestore.firestore()
    let auth = Auth.auth()

    var conversationListener: ListenerRegistration?
    var chatListener: ListenerRegistration?

    init() {
        self.showSignIn = Auth.auth().currentUser == nil
    }
    
    public func refreshReplies() {

        if quickReplySuggestion.isEmpty {
            quickReplySuggestion = quickReplies[quickReplyPosition]
            return
        }
        
        if quickReplyPosition == 2 {
            quickReplyPosition = 0
        } else {
            quickReplyPosition += 1
        }
        
        quickReplySuggestion = quickReplies[quickReplyPosition]
    }

}

// Search
extension AppState {
    func searchUsers(queryText: String, completion: @escaping ([String]) -> Void) {
        database.collection("users").getDocuments { snapshot, error in
            guard let usernames = snapshot?.documents.compactMap({ $0.documentID }), error == nil
            else {
                completion([])
                return
            }
            
            let filtered = usernames.filter({ $0.lowercased().hasPrefix(queryText.lowercased())})

            completion(filtered)
        }
    }
}

//Conversation
extension AppState {
    func getConversations() {
        //listen
        conversationListener = database
            .collection("users")
            .document(currentUsername.lowercased())
            .collection("chats").addSnapshotListener { [weak self] snapshot, error in
                guard let usernames = snapshot?.documents.compactMap({ $0.documentID }),
                      error == nil else {
                    return
                }

                DispatchQueue.main.async {
                    self?.conversations = usernames
                }
            }
    }
}

// get chat and send message
extension AppState {
    func observeChat() {
        createConversation()

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
                    self?.messages = messages
                }
            }
    }

    func sendMessage(text: String) {
        let newMessageId = UUID().uuidString
        let dateString = ISO8601DateFormatter().string(from: Date())

        guard !dateString.isEmpty,
              !otherUsername.isEmpty,
              !text.isEmpty
        else {
            return
        }

        let data = [
            "text": text,
            "sender": currentUsername.lowercased(),
            "created": dateString
        ]

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

    func createConversation() {

    }
}


// Sign In & Sign Up
extension AppState {

    func signIn(username: String, password: String) {
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
                }
            })
        }
    }

    func signUp(email: String, username: String, password: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil,
                    error == nil
            else { return }

            let data = [
                "email": email,
                "username": username
            ]

            print("Got data")

            self?.database.collection("users").document(username).setData(data) {
                err in
                guard err == nil else { return }
            }

            print("In base")

            DispatchQueue.main.async {
                self?.currentEmail = email
                self?.currentUsername = username
                self?.showSignIn = false
            }
        }
    }

    func signOut() {
        do {
            try auth.signOut()
            self.showSignIn = true
        }
        catch {
            print(error)
        }
    }
}
