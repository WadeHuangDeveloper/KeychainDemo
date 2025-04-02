//
//  UserRepository.swift
//  KeychainDemo
//
//  Created by Huei-Der Huang on 2025/3/31.
//

import Foundation

class UserRepository: UserRepositoryProtocol {
    
    func read() throws -> UserModel? {
        do {
            guard let account = UserDefaultsService.shared.get(key: .account),
                  let passwordData = try KeychainService.shared.read(key: .password, service: AppResource.bundleId, account: account),
                  let password = String(data: passwordData, encoding: .utf8) else {
                return nil
            }
            return UserModel(account: account, password: password)
        } catch {
            throw UserRepositoryError.read(error)
        }
    }
    
    func createOrUpdate(account: String, password: String) throws {
        do {
            if let _ = try read() {
                UserDefaultsService.shared.set(key: .account, value: account)
                try KeychainService.shared.update(key: .password, service: AppResource.bundleId, account: account, password: password)
            } else {
                UserDefaultsService.shared.set(key: .account, value: account)
                try KeychainService.shared.create(key: .password, service: AppResource.bundleId, account: account, password: password)
            }
        } catch {
            throw UserRepositoryError.createOrUpdate(error)
        }
    }
    
    func delete(account: String, password: String) throws {
        do {
            if let _ = try read() {
                UserDefaultsService.shared.delete(key: .account)
                try KeychainService.shared.delete(key: .password, service: AppResource.bundleId, account: account)
            } else {
                let error = NSError(domain: "\(Self.self)", code: 404, userInfo: [NSLocalizedDescriptionKey: "\(#function) not found"])
                throw error
            }
        } catch {
            throw UserRepositoryError.delete(error)
        }
    }
}
