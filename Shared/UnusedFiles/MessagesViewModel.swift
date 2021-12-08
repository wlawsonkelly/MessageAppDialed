//
//  MessagesViewModel.swift
//  TestMessaging
//
//  Created by William Carter on 10/12/21.
//

import Foundation
import SwiftUI

enum Field: Hashable {
       case compose
       case recipient
   }

class MessagesViewModel: ObservableObject {
        
    @Published var recipientField: String = ""
    @Published var composeText: String = "Write something!"
    
    var quickReplyPosition: Int = 0
    @Published var quickReplySuggestion: String = ""
    
    @Published var messages: [Message] = []
    
    @Published var previewMedia = [String]()
    
    @Published var quickReplies: [String] = [
        "Sure that works",
        "No problem",
        "I'm on it"
    ]
    
//    @Published var contacts: [Contact] = [
//        Contact(phoneNumber: "9177449835", name: "Lawson"),
//        Contact(phoneNumber: "6173229890", name: "Kevin"),
//        Contact(phoneNumber: "6463329871", name: "Sarah"),
//        Contact(phoneNumber: "6463329871", name: "Jake"),
//        Contact(phoneNumber: "6463329871", name: "Carol"),
//        Contact(phoneNumber: "6463329871", name: "Jim")
//    ]
    
    /*@Published var searchResults = [
     
        "Will Carter",
        "James Taylor"
    ]*/
    
//    @Published var searchResults = [Contact]()

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
//    
//    func searchUsers(queryText: String, completion: @escaping ([Contact]) -> Void) {
//        
//        let filtered = contacts.filter({ $0.name.lowercased().hasPrefix(queryText.lowercased())})
//
//            completion(filtered)
//    }
}
