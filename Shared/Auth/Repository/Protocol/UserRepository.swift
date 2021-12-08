//
//  UserRepository.swift
//  MessageApp
//
//  Created by Lawson Kelly  on 12/7/21.
//

import Foundation
import Combine

protocol UserRepository {
    var userModel: PassthroughSubject<User, Never> { get }
    // Future/Promise based
    func save(email: String, username: String, password: String) throws
    func get(username: String, password: String) throws
}
