//
//  HomeViewControllerViewModel.swift
//  KeychainDemo
//
//  Created by Huei-Der Huang on 2025/3/31.
//

import Foundation
import Combine

class HomeViewControllerViewModel {
    let repository: UserRepositoryProtocol
    let event = PassthroughSubject<UserRepositoryEvent, UserRepositoryError>()
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func read() {
        do {
            if let user = try repository.read() {
                event.send(.user(user))
            } else {
                event.send(.user(nil))
            }
        } catch {
            event.send(completion: .failure(.read(error)))
        }
    }
    
    func update(account: String, password: String) {
        do {
            try repository.createOrUpdate(account: account, password: password)
            event.send(.update)
        } catch {
            event.send(completion: .failure(.createOrUpdate(error)))
        }
    }
    
    func delete() {
        do {
            guard let account = UserDefaultsService.shared.get(key: .account),
                  let passwordData = try KeychainService.shared.read(key: .password, service: AppResource.bundleId, account: account),
                  let password = String(data: passwordData, encoding: .utf8) else {
                throw NSError(domain: "\(Self.self)", code: 404, userInfo: [NSLocalizedDescriptionKey: "\(#function) failed"])
            }
            try repository.delete(account: account, password: password)
            event.send(.delete)
        } catch {
            event.send(completion: .failure(.delete(error)))
        }
    }
}
