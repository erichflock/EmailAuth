//
//  BaseViewController.swift
//  EmailAuth
//
//  Created by Erich Flock on 27.04.22.
//

import UIKit

class BaseViewController: UIViewController {
    
    func presentAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(.init(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc
    func dismissVC() {
        dismiss(animated: true)
    }
    
}
