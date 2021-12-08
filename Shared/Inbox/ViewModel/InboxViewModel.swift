//
//  InboxViewModel.swift
//  MessageApp
//
//  Created by Lawson Kelly  on 12/7/21.
//

import Foundation
import Combine
import SwiftUI

class InboxViewModel: ObservableObject {
    @Published var usernames: [String] = []
    
    var currentUsername: String
    let inboxRepository: InboxRepository
    var cancleable = Set<AnyCancellable>()
    
    init(currentUsername: String) {
        self.currentUsername = currentUsername
        self.inboxRepository = FirebaseInboxRepository(
            currentUsername: currentUsername
        )
        observeConversations()
    }
    
    private func observeConversations() {
        self.inboxRepository.userModels.sink { users in
            self.usernames = users
        }
        .store(in: &self.cancleable)
    }
    
//    func searchUsers(queryText: String, completion: @escaping ([String]) -> Void) {
//        inboxRepository.get { usernames in
//            self.inboxRepository.userModels.sink { users in
//                let filtered = users.filter({ $0.lowercased().hasPrefix(queryText.lowercased())})
//                completion(filtered)
//            }
//            .store(in: &self.cancleable)
//        }
//    }
}
