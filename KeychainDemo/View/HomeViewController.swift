//
//  HomeViewController.swift
//  KeychainDemo
//
//  Created by Huei-Der Huang on 2025/3/31.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    let viewModel: HomeViewControllerViewModel!
    private var accountImageView = UIImageView()
    private var passwordImageView = UIImageView()
    private var accountTextField = UITextField()
    private var passwordTextField = UITextField()
    private var updateButton = UIButton(type: .roundedRect)
    private var deleteButton = UIButton(type: .roundedRect)
    private var accountStackView = UIStackView()
    private var passwordStackView = UIStackView()
    private var mainStackView = UIStackView()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: HomeViewControllerViewModel!) {
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
        navigationItem.hidesBackButton = true
        
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
        
        var updateConfig = UIButton.Configuration.filled()
        updateConfig.image = UIImageResource.update
        updateConfig.title = UITextResource.updateTitle
        updateConfig.imagePadding = 5
        updateConfig.imagePlacement = .trailing
        updateConfig.cornerStyle = .capsule
        updateButton.configuration = updateConfig
        updateButton.addTarget(self, action: #selector(onUpdateButtonClick), for: .touchUpInside)
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        
        var deleteConfig = UIButton.Configuration.filled()
        deleteConfig.image = UIImageResource.update
        deleteConfig.title = UITextResource.updateTitle
        deleteConfig.imagePadding = 5
        deleteConfig.imagePlacement = .trailing
        deleteConfig.cornerStyle = .capsule
        deleteConfig.baseBackgroundColor = .systemRed
        deleteButton.configuration = deleteConfig
        deleteButton.addTarget(self, action: #selector(onDeleteButtonClick), for: .touchUpInside)
        deleteButton.setTitle(UITextResource.deleteTitle, for: .normal)
        deleteButton.setImage(UIImageResource.delete, for: .normal)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
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
        view.addSubview(updateButton)
        view.addSubview(deleteButton)
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            accountImageView.heightAnchor.constraint(equalToConstant: 40),
            accountImageView.widthAnchor.constraint(equalToConstant: 40),
            
            passwordImageView.heightAnchor.constraint(equalToConstant: 40),
            passwordImageView.widthAnchor.constraint(equalToConstant: 40),
            
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            updateButton.heightAnchor.constraint(equalToConstant: 50),
            updateButton.widthAnchor.constraint(equalToConstant: 180),
            updateButton.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 80),
            updateButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            deleteButton.widthAnchor.constraint(equalToConstant: 180),
            deleteButton.topAnchor.constraint(equalTo: updateButton.bottomAnchor, constant: 10),
            deleteButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    
    @objc private func onUpdateButtonClick() {
        view.endEditing(true)
        
        guard let account = accountTextField.text, !account.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            self.showAlertWithOption(message: UITextResource.createAlert)
            return
        }
        showAlertTwoOptions(message: UITextResource.updateAlert) { [weak self] in
            self?.viewModel.update(account: account, password: password)
        }
    }
    
    @objc private func onDeleteButtonClick() {
        view.endEditing(true)
        
        showAlertTwoOptions(message: UITextResource.deleteAlert) { [weak self] in
            self?.viewModel.delete()
        }
    }
    
    @MainActor
    private func showAlertWithoutOptions(completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: UITextResource.SuccessAlert, preferredStyle: .alert)
        present(alertController, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alertController.dismiss(animated: true) {
                completion?()
            }
        }
    }
    
    @MainActor
    private func showAlertWithOption(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: UITextResource.okAlertTitle, style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    @MainActor
    private func showAlertTwoOptions(message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: UITextResource.yesAlertTitle, style: .default) { _ in
            completion?()
        }
        let cancelAction = UIAlertAction(title: UITextResource.cancelAlertTitle, style: .cancel)
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func setupCombine() {
        viewModel.event
            .sink { [weak self] completion in
                if case .failure(let result) = completion {
                    switch result {
                    case .createOrUpdate(let error):
                        self?.showAlertWithOption(message: error.localizedDescription)
                    case .delete(let error):
                        self?.showAlertWithOption(message: error.localizedDescription)
                    default:
                        break
                    }
                }
            } receiveValue: { [weak self] event in
                switch event {
                case .create:
                    break
                case .delete:
                    self?.showAlertWithoutOptions {
                        guard let self = self else { return }
                        self.navigationController?.popViewController(animated: true)
                    }
                case .update:
                    self?.showAlertWithoutOptions()
                case .user(let user):
                    self?.updateTextFields(account: user?.account, password: user?.password)
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    private func updateTextFields(account: String?, password: String?) {
        accountTextField.text = account
        passwordTextField.text = password
    }
}
