//
//  UserRepositoryEvent.swift
//  KeychainDemo
//
//  Created by Huei-Der Huang on 2025/4/1.
//

import Foundation

enum UserRepositoryEvent {
    case create
    case delete
    case update
    case user(UserModel?)
}
