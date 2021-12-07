//
//  Message.swift
//  TestMessaging
//
//  Created by Lawson Kelly  on 12/1/21.
//

import Foundation
import SwiftUI

enum MessageType: String {
    case sent
    case received
}

struct Message: Hashable {
    let id = UUID()
    let text: String
    let type: MessageType
    let created: Date
    var mediaUrl: String?

    func getName() -> String {
         return "Entry with id \(id.uuidString)"
    }
}
