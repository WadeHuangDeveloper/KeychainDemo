//
//  UserRepositoryProtocol.swift
//  KeychainDemo
//
//  Created by Huei-Der Huang on 2025/3/31.
//

import Foundation

protocol UserRepositoryProtocol {
    func read() throws -> UserModel?
    func createOrUpdate(account: String, password: String) throws
    func delete(account: String, password: String) throws
}
