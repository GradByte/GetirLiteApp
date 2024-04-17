//
//  ProductDetailViewController.swift
//  GetirLiteApp
//
//  Created by GradByte on 17.04.2024.
//

import Foundation
import UIKit
import Kingfisher

final class ProductDetailViewController: UIViewController, ProductDetailViewControllerProtocol {
    
    private let containerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = GetirColor.purple
        label.textAlignment = .center
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let attributeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    private let lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = GetirColor.almostWhiteGray
        return lineView
    }()
    
    private let lineViewForButton: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = GetirColor.almostWhiteGray
        return lineView
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sepete Ekle", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.backgroundColor = GetirColor.purple
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let presenter: ProductDetailPresenter
    
    private let imageURL: String
    private let name: String
    private let price: String
    private let attribute: String
    
    init(presenter: ProductDetailPresenter, imageURL: String, name: String, price: String, attribute: String) {
        self.presenter = presenter
        
        self.imageURL = imageURL
        self.name = name
        self.price = price
        self.attribute = attribute
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad(view: self)
        setupNavigationBar()
        setupUI()
        setupContent()
    }
    
}

// MARK: - Setup UI elements
extension ProductDetailViewController {
    private func setupUI() {
        view.backgroundColor = .white
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        view.addSubview(addButton)
        view.addSubview(lineViewForButton)
        
        containerView.addSubview(imageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(attributeLabel)
        containerView.addSubview(lineView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        attributeLabel.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineViewForButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            priceLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            priceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            attributeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            attributeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            attributeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            attributeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            lineView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20),
            lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 3),
            
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            
            lineViewForButton.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -25),
            lineViewForButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineViewForButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineViewForButton.heightAnchor.constraint(equalToConstant: 3)
        ])
    }
    
    private func setupContent() {
        // Load image using Kingfisher
        if let url = URL(string: imageURL) {
            imageView.kf.setImage(with: url)
        }
        
        // Set text for labels
        nameLabel.text = name
        priceLabel.text = price
        attributeLabel.text = attribute
    }
    
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
        title = "Ürün Detayı"
        
        
        navigationItem.leftBarButtonItem = createCloseButton()
        if LocalData.shared.totalBill > 0.0 {
            navigationItem.rightBarButtonItem = navbarBasketButton()
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem()
        }
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
    
    private func navbarBasketButton() -> UIBarButtonItem {
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 36))
        
        let bagView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        bagView.backgroundColor = .white
        
        let imageView = UIImageView(frame: CGRect(x: (bagView.bounds.width - 32) / 2, y: (bagView.bounds.height - 32) / 2, width: 32, height: 32))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "bag1")
        
        bagView.addSubview(imageView)
        containerView.addSubview(bagView)
        
        let billView = UIView(frame: CGRect(x: 36, y: 0, width: 64, height: 36))
        billView.backgroundColor = GetirColor.almostWhiteGray
        
        let billLabel = UILabel(frame: billView.bounds)
        billLabel.textAlignment = .center
        billLabel.textColor = GetirColor.purple
        billLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold) // Reduce font size to fit
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₺"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        if let formattedAmount = formatter.string(from: NSNumber(value: LocalData.shared.totalBill)) {
            billLabel.text = formattedAmount
        }
        billView.addSubview(billLabel)
        containerView.addSubview(billView)
        
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.navbarBasketButtonTapped))
        containerView.addGestureRecognizer(gesture)
        
        let customButton = UIBarButtonItem(customView: containerView)
        
        return customButton
    }
    
    // Action for the navbarBasketButton
    @objc private func navbarBasketButtonTapped() {
        self.presenter.routeToShoppingCart()
    }
}
