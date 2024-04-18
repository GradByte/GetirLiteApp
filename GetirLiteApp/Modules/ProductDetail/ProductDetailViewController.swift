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
    
    private let defaultAddButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sepete Ekle", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.backgroundColor = GetirColor.purple
        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 3
        button.layer.masksToBounds = false
        let plusImage = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        let tintedPlusImage = plusImage?.withTintColor(GetirColor.purple, renderingMode: .alwaysOriginal)
        button.setImage(tintedPlusImage, for: .normal)
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // Add a label below the plus button
    var quantityLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = GetirColor.purple
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    private let minusButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 3
        button.layer.masksToBounds = false
        
        let minusImage = UIImage(systemName: "minus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        let tintedMinusImage = minusImage?.withTintColor(GetirColor.purple, renderingMode: .alwaysOriginal)
        button.setImage(tintedMinusImage, for: .normal)
        
        button.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private var buttonStackView: UIStackView = {
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 0
        buttonStackView.alignment = .center
        buttonStackView.distribution = .fillEqually
        return buttonStackView
    }()
    
    private let presenter: ProductDetailPresenter
    
    private var product: Product? = nil
    private var imageURL: String = ""
    private var name: String = ""
    private var price: String = ""
    private var attribute: String = ""
    
    init(presenter: ProductDetailPresenter, product: Product) {
        self.presenter = presenter
        
        self.imageURL = product.imageURLString ?? ""
        self.name = product.name ?? "Ürün İsmi"
        
        
        var formattedPrice: String? {
            guard let priceString = product.price else { return nil }
                
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencySymbol = "₺"
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
                
            return formatter.string(from: NSNumber(value: priceString))
        }
        
        self.price = formattedPrice ?? "₺0.00"
        
        self.attribute = product.attributeString ?? "Ürün"
        self.product = product
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad(view: self)
        setupUI()
        setupNavigationBar()
        setupAddButton()
        setupContent()
    }
    
}

// MARK: - Setup UI elements
extension ProductDetailViewController {
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(containerView)
        view.addSubview(lineViewForButton)
        view.addSubview(buttonStackView)
        view.addSubview(defaultAddButton)
        
        containerView.addSubview(imageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(attributeLabel)
        containerView.addSubview(lineView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        attributeLabel.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineViewForButton.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        defaultAddButton.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonHeight: CGFloat = 50
        minusButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        quantityLabel.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        if quantityLabel.text == "1" {
            let trashImage = UIImage(named: "purpleTrash")
            let tintedTrashImage = trashImage?.withTintColor(GetirColor.purple, renderingMode: .alwaysOriginal)
            minusButton.setImage(tintedTrashImage, for: .normal)
        } else {
            let minusImage = UIImage(systemName: "minus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
            let tintedMinusImage = minusImage?.withTintColor(GetirColor.purple, renderingMode: .alwaysOriginal)
            minusButton.setImage(tintedMinusImage, for: .normal)
        }
        
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
            
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -120),
            
            lineViewForButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            lineViewForButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineViewForButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineViewForButton.heightAnchor.constraint(equalToConstant: 3),
            
            defaultAddButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            defaultAddButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            defaultAddButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            defaultAddButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    private func setupAddButton() {
        
        if let currentProduct = product {
            if LocalData.shared.selectedProducts[currentProduct] == nil {
                addButton.isHidden = true
                quantityLabel.isHidden = true
                minusButton.isHidden = true
                buttonStackView.isHidden = true
                defaultAddButton.isHidden = false
            } else {
                addButton.isHidden = false
                quantityLabel.isHidden = false
                minusButton.isHidden = false
                buttonStackView.isHidden = false
                defaultAddButton.isHidden = true
                quantityLabel.text = ("\(LocalData.shared.selectedProducts[currentProduct] ?? 0)")
            }
        }
        
        buttonStackView.removeArrangedSubview(minusButton)
        buttonStackView.removeArrangedSubview(quantityLabel)
        buttonStackView.removeArrangedSubview(addButton)
        buttonStackView.addArrangedSubview(minusButton)
        buttonStackView.addArrangedSubview(quantityLabel)
        buttonStackView.addArrangedSubview(addButton)
        
        setupUI()
        setupNavigationBar()
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
}

// MARK: - Data injection to UI elements
extension ProductDetailViewController {
    private func setupContent() {
        if let url = URL(string: imageURL) {
            imageView.kf.setImage(with: url)
        }
        nameLabel.text = name
        priceLabel.text = price
        attributeLabel.text = attribute
    }
}


// MARK: - Navbar Items
extension ProductDetailViewController {
    private func createCloseButton() -> UIBarButtonItem {
        let closeButton = UIButton(type: .custom)
        let xImage = UIImage(named: "x_button")
        
        closeButton.setImage(xImage, for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        containerView.addSubview(closeButton)
        
        let closeBarButtonItem = UIBarButtonItem(customView: containerView)
        return closeBarButtonItem
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
        billLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        
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
}


// MARK: - Button actions
extension ProductDetailViewController {
    @objc private func plusButtonTapped() {
        if let currentProduct = product {
            LocalData.shared.totalBill += currentProduct.price ?? 0.0
            if (LocalData.shared.selectedProducts[currentProduct] != nil) {
                LocalData.shared.selectedProducts[currentProduct]! += 1
            } else {
                LocalData.shared.selectedProducts[currentProduct] = 1
            }
        }
        
        setupUI()
        setupNavigationBar()
        setupAddButton()
    }
    
    @objc private func minusButtonTapped() {
        
        if let currentProduct = product {
            LocalData.shared.totalBill -= currentProduct.price ?? 0.0
            if (LocalData.shared.selectedProducts[currentProduct] != nil) {
                LocalData.shared.selectedProducts[currentProduct]! -= 1
                if LocalData.shared.selectedProducts[currentProduct]! == 0 {
                    LocalData.shared.selectedProducts.removeValue(forKey: currentProduct)
                }
            }
        }
        
        if LocalData.shared.selectedProducts.isEmpty {
            LocalData.shared.totalBill = 0.0
        }
        
        setupUI()
        setupNavigationBar()
        setupAddButton()
    }
}


// MARK: - Navbar Button Actions
extension ProductDetailViewController {
    
    @objc private func navbarBasketButtonTapped() {
        self.presenter.routeToShoppingCart()
    }
    
    @objc func closeButtonTapped() {
        self.presenter.routeToProductListing()
    }
}
