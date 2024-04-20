//
//  ProductDetailViewController.swift
//  GetirLiteApp
//
//  Created by GradByte on 17.04.2024.
//

import Foundation
import UIKit
import Kingfisher

final class ProductDetailViewController: UIViewController {
    
    // UI Elements
    let containerView = UIView()
    let imageView = UIImageView()
    let priceLabel = UILabel()
    let nameLabel = UILabel()
    let attributeLabel = UILabel()
    let lineView = UIView()
    let lineViewForButton = UIView()
    let defaultAddButton = UIButton()
    let addButton = UIButton()
    let minusButton = UIButton()
    var buttonStackView = UIStackView()
    var quantityLabel = UILabel()
    
    private let presenter: ProductDetailPresenter
    
    init(presenter: ProductDetailPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad(view: self)
        doneSetupContent()
    }
    
}

extension ProductDetailViewController: ProductDetailViewControllerProtocol {
    
    func doneSetupContent() {
        setupUI()
        setupNavigationBar()
        setupAddButton()
    }
}

// MARK: - Setup UI Elements Positions
extension ProductDetailViewController {
    func setupUI() {
        setupElements()
        
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
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false

        let buttonHeight: CGFloat = 50
        NSLayoutConstraint.activate([
            minusButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            quantityLabel.heightAnchor.constraint(equalToConstant: buttonHeight),
            addButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
        
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
    
    func setupAddButton() {
        if let currentProduct = self.presenter.product {
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
}

// MARK: - Setting up Navigation
extension ProductDetailViewController {
    func setupNavigationBar() {
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
        
        navigationItem.leftBarButtonItem = NavbarItems.shared.createCloseButton(detailPagePresenter: self.presenter)
        if LocalData.shared.totalBill > 0.0 {
            navigationItem.rightBarButtonItem = NavbarItems.shared.navbarBasketButton(detailPagePresenter: self.presenter)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem()
        }
    }
}

// MARK: - Setting up variable styles
extension ProductDetailViewController {
    func setupElements() {
        // Image View
        imageView.contentMode = .scaleAspectFit
        
        // Price Label
        priceLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        priceLabel.textColor = GetirColor.purple
        priceLabel.textAlignment = .center
        
        // Name Label
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        
        // Attribute Label
        attributeLabel.font = UIFont.systemFont(ofSize: 14)
        attributeLabel.numberOfLines = 0
        attributeLabel.textColor = .gray
        attributeLabel.textAlignment = .center
        
        // Line View and Live View For Button
        lineView.backgroundColor = GetirColor.almostWhiteGray
        lineViewForButton.backgroundColor = GetirColor.almostWhiteGray
        
        // Default Add Button (NOT SELECTED ALREADY)
        defaultAddButton.addTarget(self.presenter, action: #selector(self.presenter.plusButtonTapped), for: .touchUpInside)
        defaultAddButton.setTitle("Sepete Ekle", for: .normal)
        defaultAddButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        defaultAddButton.backgroundColor = GetirColor.purple
        defaultAddButton.layer.cornerRadius = 10
        defaultAddButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        // Add Button (SELECTED ALREADY)
        addButton.addTarget(self.presenter, action: #selector(self.presenter.plusButtonTapped), for: .touchUpInside)
        addButton.backgroundColor = .white
        addButton.layer.cornerRadius = 10
        addButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        addButton.layer.shadowOpacity = 0.2
        addButton.layer.shadowRadius = 3
        addButton.layer.masksToBounds = false
        let plusImage = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        let tintedPlusImage = plusImage?.withTintColor(GetirColor.purple, renderingMode: .alwaysOriginal)
        addButton.setImage(tintedPlusImage, for: .normal)
        
        // Minus Button
        minusButton.addTarget(self.presenter, action: #selector(self.presenter.minusButtonTapped), for: .touchUpInside)
        minusButton.backgroundColor = .white
        minusButton.layer.cornerRadius = 10
        minusButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        minusButton.layer.shadowColor = UIColor.black.cgColor
        minusButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        minusButton.layer.shadowOpacity = 0.2
        minusButton.layer.shadowRadius = 3
        minusButton.layer.masksToBounds = false
        let minusImage = UIImage(systemName: "minus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        let tintedMinusImage = minusImage?.withTintColor(GetirColor.purple, renderingMode: .alwaysOriginal)
        minusButton.setImage(tintedMinusImage, for: .normal)
        
        // Button Stack View
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 0
        buttonStackView.alignment = .center
        buttonStackView.distribution = .fillEqually
        
        // Quantity Label
        quantityLabel.backgroundColor = GetirColor.purple
        quantityLabel.textColor = .white
        quantityLabel.textAlignment = .center
        quantityLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        if quantityLabel.text == "1" {
            let trashImage = UIImage(named: "purpleTrash")
            let tintedTrashImage = trashImage?.withTintColor(GetirColor.purple, renderingMode: .alwaysOriginal)
            minusButton.setImage(tintedTrashImage, for: .normal)
        } else {
            let minusImage = UIImage(systemName: "minus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
            let tintedMinusImage = minusImage?.withTintColor(GetirColor.purple, renderingMode: .alwaysOriginal)
            minusButton.setImage(tintedMinusImage, for: .normal)
        }
    }
}
