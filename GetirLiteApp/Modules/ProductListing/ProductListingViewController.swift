//
//  ProductListingViewController.swift
//  GetirLiteApp
//
//  Created by GradByte on 15.04.2024.
//

import Foundation
import UIKit

final class ProductListingViewController: UIViewController, ProductListingViewControllerProtocol {
    
    private var label: UILabel = {
        let label = UILabel()
        label.text = "ProductListingView"
        label.textColor = GetirColor.yellow
        return label
    }()
    
    private let presenter: ProductListingPresenter
    
    init(presenter: ProductListingPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad(view: self)
        setupUI()
        //NetworkingManager.shared.fetchMainProducts()
        //NetworkingManager.shared.fetchSuggestedProducts()
        setupNavigationBar()
    }
}

// MARK: - Setup UI Elements
extension ProductListingViewController {
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = GetirColor.purple
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        title = "Ürünler"
        
        // Set the bar button item to the navigation item's rightBarButtonItem
        navigationItem.rightBarButtonItem = navbarBasketButton()
        
    }
    
    private func navbarBasketButton() -> UIBarButtonItem {
        
        // Create a container view to hold the custom button
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 36))
        
        // Create the bagView section
        let bagView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 36))
        bagView.backgroundColor = .white
        // Create an image view
        let imageView = UIImageView(frame: CGRect(x: (bagView.bounds.width - 15) / 2, y: (bagView.bounds.height - 15) / 2, width: 15, height: 15))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "bag.jpeg")
        // Add the image view as a subview of the white view
        bagView.addSubview(imageView)
        containerView.addSubview(bagView)
        
        // Create the billView section
        let billView = UIView(frame: CGRect(x: 30, y: 0, width: 70, height: 36))
        billView.backgroundColor = GetirColor.almostWhiteGray
        
        // Create a label for the current bill amount
        let billLabel = UILabel(frame: billView.bounds)
        billLabel.textAlignment = .center
        billLabel.textColor = GetirColor.purple
        billLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold) // Reduce font size to fit
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₺"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        if let formattedAmount = formatter.string(from: NSNumber(value: 0.00)) {
            billLabel.text = formattedAmount
        }
        billView.addSubview(billLabel)
        containerView.addSubview(billView)
        
        // Container view corner radius
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = true
        
        // Create a bar button item with the container view
        let customButton = UIBarButtonItem(customView: containerView)
        return customButton
    }
}
