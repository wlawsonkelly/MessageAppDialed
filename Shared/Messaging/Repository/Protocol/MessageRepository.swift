//
//  MessageRepository.swift
//  MessageApp
//
//  Created by Lawson Kelly  on 12/7/21.
//

import Foundation
import Combine

enum MessageRepositoryError: Error {
    case invalidData
}

protocol MessageRepository {
    var messageModels: PassthroughSubject<[Message], Never> { get }
    // Future/Promise based
    func save(text: String) throws
}
