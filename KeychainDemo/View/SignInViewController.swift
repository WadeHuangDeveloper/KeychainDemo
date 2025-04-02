//
//  SignInViewController.swift
//  KeychainDemo
//
//  Created by Huei-Der Huang on 2025/3/31.
//

import UIKit
import Combine

class SignInViewController: UIViewController {
    let viewModel: SignInViewControllerViewModel!
    private var accountImageView = UIImageView()
    private var passwordImageView = UIImageView()
    private var accountTextField = UITextField()
    private var passwordTextField = UITextField()
    private var createButton = UIButton(type: .roundedRect)
    private var accountStackView = UIStackView()
    private var passwordStackView = UIStackView()
    private var mainStackView = UIStackView()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: SignInViewControllerViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupCombine()
        viewModel.read()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        cancellables.removeAll()
    }
    
    private func initUI() {
        accountImageView.image = UIImageResource.account
        accountImageView.contentMode = .scaleAspectFit
        accountImageView.translatesAutoresizingMaskIntoConstraints = false
        
        passwordImageView.image = UIImageResource.password
        passwordImageView.contentMode = .scaleAspectFit
        passwordImageView.translatesAutoresizingMaskIntoConstraints = false
        
        accountTextField.placeholder = UITextResource.accountPlaceholder
        accountTextField.borderStyle = .roundedRect
        accountTextField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordTextField.placeholder = UITextResource.passwordPlaceholder
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        var createConfig = UIButton.Configuration.filled()
        createConfig.image = UIImageResource.create
        createConfig.title = UITextResource.createTitle
        createConfig.imagePadding = 5
        createConfig.imagePlacement = .trailing
        createConfig.cornerStyle = .capsule
        createButton.configuration = createConfig
        createButton.addTarget(self, action: #selector(onCreateButtonClick), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        accountStackView.addArrangedSubview(accountImageView)
        accountStackView.addArrangedSubview(accountTextField)
        accountStackView.axis = .horizontal
        accountStackView.alignment = .fill
        accountStackView.distribution = .fill
        accountStackView.spacing = 10
        accountStackView.translatesAutoresizingMaskIntoConstraints = false
        
        passwordStackView.addArrangedSubview(passwordImageView)
        passwordStackView.addArrangedSubview(passwordTextField)
        passwordStackView.axis = .horizontal
        passwordStackView.alignment = .fill
        passwordStackView.distribution = .fill
        passwordStackView.spacing = 10
        passwordStackView.translatesAutoresizingMaskIntoConstraints = false
        
        mainStackView.addArrangedSubview(accountStackView)
        mainStackView.addArrangedSubview(passwordStackView)
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        mainStackView.spacing = 10
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainStackView)
        view.addSubview(createButton)
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            accountImageView.heightAnchor.constraint(equalToConstant: 40),
            accountImageView.widthAnchor.constraint(equalToConstant: 40),
            
            passwordImageView.heightAnchor.constraint(equalToConstant: 40),
            passwordImageView.widthAnchor.constraint(equalToConstant: 40),
            
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            createButton.heightAnchor.constraint(equalToConstant: 50),
            createButton.widthAnchor.constraint(equalToConstant: 180),
            createButton.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 80),
            createButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }

    @objc private func onCreateButtonClick() {
        view.endEditing(true)
        
        guard let account = accountTextField.text, !account.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlertWithOption(message: UITextResource.createAlert)
            return
        }
        viewModel.create(account: account, password: password)
    }
    
    @MainActor
    private func showAlertWithOption(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: UITextResource.okAlertTitle, style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    @MainActor
    private func showAlertWithoutOptions() {
        let alertController = UIAlertController(title: nil, message: UITextResource.SuccessAlert, preferredStyle: .alert)
        present(alertController, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alertController.dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                self.navigateToHomeViewController()
            }
        }
    }
    
    private func setupCombine() {
        viewModel.event
            .sink { [weak self] completion in
                if case .failure(.createOrUpdate(let error)) = completion {
                    self?.showAlertWithOption(message: error.localizedDescription)
                }
            } receiveValue: { [weak self] event in
                switch event {
                case .create:
                    self?.showAlertWithoutOptions()
                case .user(let user):
                    self?.updateTextFields(account: user?.account, password: user?.password)
                    guard let account = user?.account, !account.isEmpty,
                          let password = user?.password, !password.isEmpty else {
                        return
                    }
                    self?.navigateToHomeViewController()
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    private func updateTextFields(account: String?, password: String?) {
        accountTextField.text = account
        passwordTextField.text = password
    }
    
    @MainActor
    private func navigateToHomeViewController() {
        let viewController = AppFactory.makeHomeViewController(repository: self.viewModel.repository)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
