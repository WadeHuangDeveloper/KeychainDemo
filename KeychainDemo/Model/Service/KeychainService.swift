//
//  KeychainService.swift
//  KeychainDemo
//
//  Created by Huei-Der Huang on 2025/3/31.
//

import Foundation

enum KeychainServiceKey: String {
    case password
}

class KeychainService {
    static let shared = KeychainService()
    
    private init() {}
    
    func read(key: KeychainServiceKey, service: String, account: String) throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimitOne as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecSuccess {
            if let data = result as? Data {
                return data
            } else {
                return nil
            }
        } else {
            print("\(Self.self).\(#function) error status: \(status.description)")
            return nil
        }
    }
    
    func create(key: KeychainServiceKey, service: String, account: String, password: String) throws {
        guard let value = password.data(using: .utf8) else {
            throw KeychainServiceError.invalidValue
        }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: value
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("\(Self.self).\(#function) error status: \(status.description)")
            throw KeychainServiceError.create(status)
        }
    }
    
    func update(key: KeychainServiceKey, service: String, account: String, password: String) throws {
        guard let value = password.data(using: .utf8) else {
            throw KeychainServiceError.invalidValue
        }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        let attributes: [String: Any] = [
            kSecValueData as String: value
        ]
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        if status != errSecSuccess {
            print("\(Self.self).\(#function) error status: \(status.description)")
            throw KeychainServiceError.update(status)
        }
    }
    
    func delete(key: KeychainServiceKey, service: String, account: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print("\(Self.self).\(#function) error status: \(status.description)")
            throw KeychainServiceError.delete(status)
        }
    }
}
