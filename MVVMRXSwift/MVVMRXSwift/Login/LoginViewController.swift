//
//  LoginViewController.swift
//  MVVMRXSwift
//
//  Created by Usr_Prime on 17/11/22.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Email"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var entryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onTapButtonLogin), for: .touchUpInside)
        return button
    }()
    
    var bag = DisposeBag()
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
        createObservable()
    }
    
    func setupView() {
        self.view.backgroundColor = .white
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(entryButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            entryButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            entryButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            entryButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            entryButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func createObservable() {
        emailTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.email).disposed(by: bag)
        passwordTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.password).disposed(by: bag)
        
        viewModel.isValidInput.bind(to: entryButton.rx.isEnabled).disposed(by: bag)
        viewModel.isValidInput.subscribe( onNext: { [weak self] isValid in
            self?.entryButton.backgroundColor = isValid ? .systemBlue : .red
        }).disposed(by: bag)
    }
    
    @objc func onTapButtonLogin() {
        print("Logar")
    }
}
