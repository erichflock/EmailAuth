//
//  PasswordlessSignInViewController.swift
//  EmailAuth
//
//  Created by Erich Flock on 26.04.22.
//

import UIKit
import Firebase

class PasswordlessSignInViewController: BaseViewController {
    
    let emailTextField = UITextField()
    let sendLinkButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Passwordless"
        
        navigationItem.leftBarButtonItem  = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissVC))
        
        setupUI()
    }
    
    private func setupUI() {
        setupView()
        setupEmailTextField()
        setupSendLinkButton()
    }
    
    private func setupView() {
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func setupEmailTextField() {
        emailTextField.placeholder = "Enter your email address"
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.spellCheckingType = .no
        
        view.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupSendLinkButton() {
        var config = UIButton.Configuration.tinted()
        config.title = "Send Link"
        
        sendLinkButton.configuration = config
        sendLinkButton.addTarget(self, action:#selector(sendEmailLinkSignIn), for: .touchUpInside)
        
        view.addSubview(sendLinkButton)
        sendLinkButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendLinkButton.topAnchor.constraint(equalTo: emailTextField.topAnchor, constant: 50),
            sendLinkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc
    private func sendEmailLinkSignIn() {
        guard let email = emailTextField.text, !email.isEmpty else {
            presentAlert(title: "Email Empty", message: "Please, enter a valid email")
            return
        }
        
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://integratefirebase-f2417.firebaseapp.com")
        actionCodeSettings.dynamicLinkDomain = "flocklearnacademy.page.link"
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        actionCodeSettings.setAndroidPackageName("com.example.android", installIfNotAvailable: false, minimumVersion: "12")
        
        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { [weak self] error in
            
            DynamicLinks.performDiagnostics(completion: nil)
            
            if let error = error {
                self?.presentAlert(title: "Send Link Error", message: error.localizedDescription)
            }
            
            UserDefaults.standard.set(email, forKey: "Email")
            
            self?.presentAlert(title: "Link Sent", message: "Please, check your email for link")
        }
    }
    
}

