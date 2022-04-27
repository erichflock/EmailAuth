//
//  EmailPasswordViewController.swift
//  EmailAuth
//
//  Created by Erich Flock on 27.04.22.
//

import UIKit
import Firebase

class EmailPasswordViewController: BaseViewController {
    
    private let signInStackView = UIStackView()
    private let signOutStackView = UIStackView()
    private let welcomeLabel = UILabel()
    private let signOutButton = UIButton()
    private let textFieldStackView = UIStackView()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let buttonStackView = UIStackView()
    private let createUserButton = UIButton()
    private let signInButton = UIButton()
    private let resetPasswordButton = UIButton()
    
    private var isUserLoggedIn: Bool {
        Auth.auth().currentUser != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Email Password"
        
        navigationItem.leftBarButtonItem  = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissVC))
        
        setupUI()
        updateSignState()
    }
    
    private func setupUI() {
        setupView()
        setupSignInStackView()
        setupSignOutStackView()
        setupTextFieldStackView()
        setupButtonStackView()
        setupWelcomeLabel()
        setupEmailTextField()
        setupPasswordTextField()
        setupCreateUserButton()
        setupSignInButton()
        setupSignOutButton()
        setupResetPasswordButton()
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupWelcomeLabel() {
        welcomeLabel.numberOfLines = 0
    }
    
    private func setupSignInStackView() {
        signInStackView.axis = .vertical
        signInStackView.spacing = 20
        
        view.addSubview(signInStackView)
        signInStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            signInStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signInStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        signInStackView.addArrangedSubview(textFieldStackView)
        signInStackView.addArrangedSubview(buttonStackView)
    }
    
    private func setupSignOutStackView() {
        signOutStackView.axis = .vertical
        signOutStackView.spacing = 40
        
        view.addSubview(signOutStackView)
        signOutStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signOutStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            signOutStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signOutStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        let signOutButtonContainer = UIView()
        signOutButtonContainer.addSubview(signOutButton)
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signOutButton.centerXAnchor.constraint(equalTo: signOutButtonContainer.centerXAnchor),
            signOutButton.topAnchor.constraint(equalTo: signOutButtonContainer.topAnchor),
            signOutButton.bottomAnchor.constraint(equalTo: signOutButtonContainer.bottomAnchor)
        ])
        
        signOutStackView.addArrangedSubview(welcomeLabel)
        signOutStackView.addArrangedSubview(signOutButtonContainer)
    }
    
    private func setupTextFieldStackView() {
        textFieldStackView.axis = .vertical
        textFieldStackView.spacing = 16
        textFieldStackView.alignment = .leading
        
        textFieldStackView.addArrangedSubview(emailTextField)
        textFieldStackView.addArrangedSubview(passwordTextField)
    }
    
    private func setupButtonStackView() {
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 16
        buttonStackView.alignment = .center
        
        buttonStackView.addArrangedSubview(createUserButton)
        buttonStackView.addArrangedSubview(signInButton)
        buttonStackView.addArrangedSubview(resetPasswordButton)
    }
    
    private func setupEmailTextField() {
        emailTextField.placeholder = "Enter your email address"
        emailTextField.autocapitalizationType = .none
        emailTextField.returnKeyType = .next
        emailTextField.autocorrectionType = .no
        emailTextField.spellCheckingType = .no
    }
    
    private func setupPasswordTextField() {
        passwordTextField.placeholder = "Enter your password"
        passwordTextField.returnKeyType = .done
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocorrectionType = .no
        passwordTextField.spellCheckingType = .no
    }
    
    private func setupCreateUserButton() {
        createUserButton.configuration = createButtonConfig("Create User")
        createUserButton.addTarget(self, action: #selector(didTapCreateUserButton), for: .touchUpInside)
    }
    
    private func setupSignInButton() {
        signInButton.configuration = createButtonConfig("Sign In")
        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
    }
    
    private func setupSignOutButton() {
        signOutButton.configuration = createButtonConfig("Sign Out")
        signOutButton.addTarget(self, action: #selector(didTapSignOutButton), for: .touchUpInside)
    }
    
    private func setupResetPasswordButton() {
        resetPasswordButton.configuration = createButtonConfig("Reset Password")
        resetPasswordButton.addTarget(self, action: #selector(didTapResetPasswordButton), for: .touchUpInside)
    }
    
    private func createButtonConfig(_ title: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.tinted()
        config.title = title
        config.buttonSize = .medium
        
        return config
    }
    
    @objc
    private func didTapCreateUserButton() {
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else {
            showEmptyFieldsErrorAlert()
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let user = authResult?.user, error == nil else {
                self?.presentAlert(title: "Auth Error", message: error?.localizedDescription ?? "")
                return
            }
            
            self?.presentAlert(title: "Auth Success", message: "User created successfully. UID: \(user.uid)")
            
            self?.updateSignState()
        }
    }
    
    @objc
    private func didTapSignInButton() {
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else {
            showEmptyFieldsErrorAlert()
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let user = authResult?.user, error == nil else {
                self?.presentAlert(title: "Sign In Error", message: error?.localizedDescription ?? "")
                return
            }
            
            self?.presentAlert(title: "Sign In Success", message: "User logged successfully. UID: \(user.uid)")
            
            self?.updateSignState()
        }
    }
    
    @objc
    private func didTapSignOutButton() {
        do {
            try Auth.auth().signOut()
            presentAlert(title: "Sign Out Success", message: "User logged out successfully.")
            updateSignState()
        } catch {
            presentAlert(title: "Sign Out Error", message: error.localizedDescription)
        }
    }
    
    @objc
    private func didTapResetPasswordButton() {
        guard let email = emailTextField.text, !email.isEmpty else {
            showEmptyFieldsErrorAlert()
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard error == nil else {
                self?.presentAlert(title: "Reset Password Error", message: error?.localizedDescription ?? "")
                return
            }
            
            self?.presentAlert(title: "Reset Password", message: "Please, check your email for password reset")
            self?.updateSignState()
        }
    }
    
    private func showEmptyFieldsErrorAlert() {
        presentAlert(title: "Error", message: "Please, enter an email and a password")
    }
    
    private func updateSignState() {
        signInStackView.isHidden = isUserLoggedIn
        signOutStackView.isHidden = !isUserLoggedIn
        
        updateWelcomeLabel()
        clearTextFields()
    }
    
    private func updateWelcomeLabel() {
        if let email = Auth.auth().currentUser?.email {
            welcomeLabel.text = "Logged In with email: \(email)"
        } else {
            welcomeLabel.text = "Logged In"
        }
    }
    
    private func clearTextFields() {
        emailTextField.text = nil
        passwordTextField.text = nil
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
