//
//  ShoppingCartViewController.swift
//  GetirLiteApp
//
//  Created by GradByte on 17.04.2024.
//

import Foundation
import UIKit
import Kingfisher

final class ShoppingCartViewController: UIViewController {
    
    private let selectedProductCellIdentifier = "selectedProductCell"
    private let productCellIdentifier = "productCell"
    
    // UI elements
    var collectionView: UICollectionView!
    var defaultAddButton = UIStackView()
    var buttonLabel = UILabel()
    var billLabel = UILabel()
    
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
        setupUI()
    }
    
}

extension ShoppingCartViewController: ShoppingCartViewControllerProtocol {
    func getSelectedProducts() {
        self.collectionView.reloadData()
    }
    
    func getFetchedSuggestedProducts() {
        self.collectionView.reloadData()
    }
    
    func buttonIsClicked() {
        self.collectionView.reloadData()
    }
}

// MARK: - Setup UI elements
extension ShoppingCartViewController {
    private func setupUI() {
        setupElements()
        setupNavigationBar()
        setupButton()
        setupCollectionView()
    }
    
    private func setupButton() {
        view.backgroundColor = .white
        view.addSubview(defaultAddButton)
        
        defaultAddButton.addArrangedSubview(buttonLabel)
        defaultAddButton.addArrangedSubview(billLabel)
        
        let gesture = UITapGestureRecognizer(target: self.presenter, action: #selector(self.presenter.endOrderButtonTapped))
        defaultAddButton.addGestureRecognizer(gesture)
        
        // Set constraints
        defaultAddButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            defaultAddButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            defaultAddButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            defaultAddButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            defaultAddButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch sectionIndex {
            case 0:
                return LayoutItems.shared.createVerticalSectionLayoutForCart()
            case 1:
                return LayoutItems.shared.createHorizontalSectionLayoutWithHeader()
            default:
                return LayoutItems.shared.createDefaultSectionLayout()
            }
        }
        
        layout.register(BackgroundDecorationView.self, forDecorationViewOfKind: "background")
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: productCellIdentifier)
        collectionView.register(SelectedProductCell.self, forCellWithReuseIdentifier: selectedProductCellIdentifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "sectionHeader")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: defaultAddButton.topAnchor, constant: -10)
        ])
        
        collectionView.backgroundColor = GetirColor.almostWhiteGray
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    
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
        title = "Sepetim"
        
        navigationItem.leftBarButtonItem = NavbarItems.shared.createCloseButton(cartPagePresenter: self.presenter)
        navigationItem.rightBarButtonItem = NavbarItems.shared.createDeleteButton(cartPagePresenter: self.presenter)
    }
}

// MARK: - UICollectionView Data Source
extension ShoppingCartViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.presenter.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.presenter.numberOfItemsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.presenter.cellForItemAt(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        self.presenter.viewForSupplementaryElementOfKind(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
    
    private func configureCell(_ cell: ProductCell, with product: Product) {
        self.presenter.configureCell(cell, with: product)
    }
}

// MARK: - CollectionView Delegate
extension ShoppingCartViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter.didSelectItemAt(indexPath: indexPath)
    }
}

// MARK: - Alert
extension ShoppingCartViewController {
    func alertOnScreen(alertController: UIAlertController) {
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Setting up UI elements
extension ShoppingCartViewController {
        
    func setupElements() {
        defaultAddButton.axis = .horizontal
        defaultAddButton.distribution = .fill
        defaultAddButton.alignment = .fill
        
        defaultAddButton.layer.cornerRadius = 10
        defaultAddButton.layer.masksToBounds = true
        
        defaultAddButton.layer.borderWidth = 1.2
        defaultAddButton.layer.borderColor = GetirColor.almostWhiteGray.cgColor
        
        buttonLabel.backgroundColor = GetirColor.purple
        buttonLabel.text = "Siparişi Tamamla"
        buttonLabel.font = .boldSystemFont(ofSize: 14)
        buttonLabel.textColor = .white
        buttonLabel.textAlignment = .center
        
        
        billLabel.backgroundColor = .white
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₺"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        if let formattedAmount = formatter.string(from: NSNumber(value: LocalData.shared.totalBill)) {
            billLabel.text = formattedAmount
        }
        billLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        billLabel.textAlignment = .center
        billLabel.textColor = GetirColor.purple
        let billLabelWidthConstraint = billLabel.widthAnchor.constraint(equalToConstant: 120)
        billLabelWidthConstraint.priority = .defaultHigh
        billLabelWidthConstraint.isActive = true
    }
}
