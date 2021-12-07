//
//  Contact.swift
//  TestMessaging
//
//  Created by Lawson Kelly  on 12/1/21.
//

import Foundation

struct Contact: Hashable {
    let id = UUID()
    var phoneNumber: String
    var name: String
}
