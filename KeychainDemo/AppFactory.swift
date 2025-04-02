//
//  AppFactory.swift
//  KeychainDemo
//
//  Created by Huei-Der Huang on 2025/4/1.
//

import Foundation
import UIKit

struct AppFactory {
    static func makeRootViewController() -> UIViewController {
        let repository = UserRepository()
        let viewModel = SignInViewControllerViewModel(repository: repository)
        let viewController = SignInViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
    
    static func makeHomeViewController(repository: UserRepositoryProtocol) -> UIViewController {
        let viewModel = HomeViewControllerViewModel(repository: repository)
        let viewController = HomeViewController(viewModel: viewModel)
        return viewController
    }
}
