//
//  SplashViewController.swift
//  GetirLiteApp
//
//  Created by GradByte on 11.04.2024.
//

import UIKit


class SplashViewController: BaseViewController {
    
    var presenter: SplashPresenterProtocol!
    
    var label: UILabel = {
        var label = UILabel()
        label.text = "getir"
        label.textColor = .yellow
        if let customFont = UIFont(name: "GillSans-Bold", size: 38) {
            label.font = customFont
        } else {
            label.font = UIFont.systemFont(ofSize: 38, weight: .bold)
        }
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidAppear()
        setupUI()
    }
    
}

// MARK: - Setup UI Elements
extension SplashViewController {
    private func setupUI() {
        view.backgroundColor = .purple
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Protocol
extension SplashViewController: SplashViewControllerProtocol {
    
    func noInternetConnection() {
        showAlert(title: "Error", message: "No Internet connection, please check your connection")
    }
}
