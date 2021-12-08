//
//  InboxRepository.swift
//  MessageApp
//
//  Created by Lawson Kelly  on 12/7/21.
//

import Foundation
import Combine

protocol InboxRepository {
    var userModels: PassthroughSubject<[String], Never> { get }
    // Future/Promise based
    func get(completion: @escaping ([String]) -> Void)
    func getConversations(completion: @escaping ([String]) -> Void)
}
