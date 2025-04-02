//
//  LoginViewControllerViewModel.swift
//  KeychainDemo
//
//  Created by Huei-Der Huang on 2025/3/31.
//

import Foundation
import Combine

class SignInViewControllerViewModel {
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
    
    func create(account: String, password: String) {
        do {
            try repository.createOrUpdate(account: account, password: password)
            event.send(.create)
        } catch {
            event.send(completion: .failure(.createOrUpdate(error)))
        }
    }
}
