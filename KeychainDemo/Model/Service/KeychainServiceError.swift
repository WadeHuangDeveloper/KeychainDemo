//
//  KeychainServiceError.swift
//  KeychainDemo
//
//  Created by Huei-Der Huang on 2025/3/31.
//

import Foundation

enum KeychainServiceError: Error {
    case read(OSStatus)
    case create(OSStatus)
    case update(OSStatus)
    case delete(OSStatus)
    case invalidValue
    case duplicatedValue
}
