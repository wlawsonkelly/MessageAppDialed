//
//  User.swift
//  TestMessaging
//
//  Created by Lawson Kelly  on 12/1/21.
//

import Foundation

struct User: Hashable {
    let id = UUID()
    let email: String
    let username: String
}
