//
//  UserRepositoryError.swift
//  KeychainDemo
//
//  Created by Huei-Der Huang on 2025/3/31.
//

import Foundation

enum UserRepositoryError: Error {
    case read(Error)
    case createOrUpdate(Error)
    case delete(Error)
}
