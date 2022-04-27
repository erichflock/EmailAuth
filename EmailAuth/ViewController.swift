//
//  ViewController.swift
//  EmailAuth
//
//  Created by Erich Flock on 26.04.22.
//

import UIKit

class ViewController: BaseViewController {

    let passwordlessLoginButton = UIButton()
    let emailPasswordLoginButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Email Authentication"
        
        setupUI()
    }
    
    private func setupUI() {
        setupView()
        setupPasswordlessLoginButton()
        setupEmailPasswordLoginButton()
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupPasswordlessLoginButton() {
        var config = UIButton.Configuration.tinted()
        config.image = UIImage(systemName: "envelope.fill")
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.title = "Passwordless"
        config.buttonSize = .large
        
        passwordlessLoginButton.configuration = config
        passwordlessLoginButton.addTarget(self, action: #selector(didTapPassowrdlessLoginButton), for: .touchUpInside)
        
        view.addSubview(passwordlessLoginButton)
        passwordlessLoginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordlessLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            passwordlessLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupEmailPasswordLoginButton() {
        var config = UIButton.Configuration.tinted()
        config.image = UIImage(systemName: "key.icloud.fill")
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.title = "Email Password"
        config.buttonSize = .large
        
        emailPasswordLoginButton.configuration = config
        emailPasswordLoginButton.addTarget(self, action: #selector(didTapEmailPasswordLoginButton), for: .touchUpInside)
        
        view.addSubview(emailPasswordLoginButton)
        emailPasswordLoginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailPasswordLoginButton.topAnchor.constraint(equalTo: passwordlessLoginButton.bottomAnchor, constant: 20),
            emailPasswordLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func didTapPassowrdlessLoginButton() {
        let vc = PasswordlessSignInViewController()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        navController.modalPresentationStyle = .formSheet
        present(navController, animated: true)
    }
    
    @objc private func didTapEmailPasswordLoginButton() {
        let vc = EmailPasswordViewController()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        navController.modalPresentationStyle = .formSheet
        present(navController, animated: true)
    }
    
}

