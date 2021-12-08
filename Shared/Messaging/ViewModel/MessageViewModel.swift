//
//  MessageViewModel.swift
//  MessageApp
//
//  Created by Lawson Kelly  on 12/7/21.
//

import SwiftUI
import Combine

class MessageViewModel: ObservableObject {
    @Published var messages: [Message] = []
        
    var currentUsername: String
    var otherUsername: String
    
    var messageRespository: MessageRepository? = nil
    
    var cancleable = Set<AnyCancellable>()
    
    init(
        currentUsername: String,
        otherUsername: String
    ) {
        print(otherUsername, " hey")
        self.currentUsername = currentUsername
        self.otherUsername = otherUsername
        self.messageRespository = FirebaseMessageRepository(
            currentUsername: currentUsername,
            otherUsername: self.otherUsername
        )
        observeMessages()
    }
    
    private func observeMessages() {
        messageRespository?.messageModels.sink { messages in
            self.messages = messages
        }
        .store(in: &cancleable)
    }
    
    func sendMessage(text: String) {
        do {
            try messageRespository?.save(text: text)
        } catch {
            print("not valid inputs")
        }
    }
}
