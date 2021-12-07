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
    
    let messageRespository: MessageRepository
    
    var cancleable = Set<AnyCancellable>()
    
    init(
        currentUsername: String,
        otherUsername: String
    ) {
        self.currentUsername = currentUsername
        self.otherUsername = otherUsername
        self.messageRespository = FirebaseMessageRepository(
            currentUsername: currentUsername,
            otherUsername: otherUsername
        )
        observeMessages()
    }
    
    private func observeMessages() {
        messageRespository.messageModels.sink { messages in
            self.messages = messages
        }
        .store(in: &cancleable)
    }
}
