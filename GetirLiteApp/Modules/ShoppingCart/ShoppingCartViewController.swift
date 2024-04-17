//
//  ShoppingCartViewController.swift
//  GetirLiteApp
//
//  Created by GradByte on 17.04.2024.
//

import Foundation
import UIKit
import Kingfisher

final class ShoppingCartViewController: UIViewController, ShoppingCartViewControllerProtocol {
    
    private let presenter: ShoppingCartPresenter
    
    init(presenter: ShoppingCartPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad(view: self)
        setupNavigationBar()
    }
    
}

// MARK: - Setup UI elements
extension ShoppingCartViewController {
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = GetirColor.purple
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 16)
        ]
        appearance.titleTextAttributes = titleTextAttributes
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        title = "Sepetim"
        
        // Assign the button to the leading navigation item
        navigationItem.leftBarButtonItem = createCloseButton()
        navigationItem.rightBarButtonItem = createDeleteButton()
    }
    private func createCloseButton() -> UIBarButtonItem {
        let closeButton = UIButton(type: .custom)
        let xImage = UIImage(named: "x_button")
        closeButton.setImage(xImage, for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        // Set the size of the button to match the image size
        closeButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        // Wrap the button in a container view to add padding if needed
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        containerView.addSubview(closeButton)
        
        // Create a UIBarButtonItem with the container view
        let closeBarButtonItem = UIBarButtonItem(customView: containerView)
        return closeBarButtonItem
    }
    
    @objc func closeButtonTapped() {
        self.presenter.routeToProductListing()
    }
    
    private func createDeleteButton() -> UIBarButtonItem {
        let deleteButton = UIButton(type: .custom)
        let trashImage = UIImage(named: "trash")
        deleteButton.setImage(trashImage, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        // Set the size of the button to match the image size
        deleteButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        // Wrap the button in a container view to add padding if needed
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        containerView.addSubview(deleteButton)
        
        // Create a UIBarButtonItem with the container view
        let deleteBarButtonItem = UIBarButtonItem(customView: containerView)
        return deleteBarButtonItem
    }
    
    @objc func deleteButtonTapped() {
        LocalData.shared.selectedMainProducts.removeAll()
        LocalData.shared.selectedSuggestedProducts.removeAll()
        LocalData.shared.totalBill = 0.0
    }
}
