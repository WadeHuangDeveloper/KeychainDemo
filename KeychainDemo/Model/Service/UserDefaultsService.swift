//
//  UserDefaultsService.swift
//  KeychainDemo
//
//  Created by Huei-Der Huang on 2025/4/1.
//

import Foundation

enum UserDefaultsServiceKey: String {
    case account
}

class UserDefaultsService {
    static let shared = UserDefaultsService()
    
    private init() {}
    
    func get(key: UserDefaultsServiceKey) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }
    
    func set(key: UserDefaultsServiceKey, value: String) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }
    
    func delete(key: UserDefaultsServiceKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
