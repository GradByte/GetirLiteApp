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
    
    var collectionView: UICollectionView!
    private let selectedProductCellIdentifier = "selectedProductCell"
    private let productCellIdentifier = "productCell"
    
    
    private var defaultAddButton: UIStackView = {
        // Create a horizontal stack view to hold the left and right parts
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true
        
        stackView.layer.borderWidth = 1.5
        stackView.layer.borderColor = GetirColor.almostWhiteGray.cgColor
        
        return stackView
    }()
    
    private var buttonLabel: UILabel = {
        // Left part: Button label with purple background
        let buttonLabel = UILabel()
        buttonLabel.backgroundColor = GetirColor.purple
        buttonLabel.text = "Siparişi Tamamla"
        buttonLabel.font = .boldSystemFont(ofSize: 14)
        buttonLabel.textColor = .white
        buttonLabel.textAlignment = .center
        
        return buttonLabel
    }()
    
    private var billLabel: UILabel = {
        // Right part: Bill label with white background
        let billLabel = UILabel()
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
        
        return billLabel
    }()
    
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
        self.updatePrice()
        self.collectionView.reloadData()
    }
}

// MARK: - Setup UI elements
extension ShoppingCartViewController {
    private func setupUI() {
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

    func updatePrice() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₺"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        if let formattedAmount = formatter.string(from: NSNumber(value: LocalData.shared.totalBill)) {
            billLabel.text = formattedAmount
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch sectionIndex {
            case 0:
                return self.createVerticalSectionLayout()
            case 1:
                return self.createHorizontalSectionLayout()
            default:
                return self.createDefaultSectionLayout()
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
    
    private func createHorizontalSectionLayout() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.boundarySupplementaryItems = [sectionHeader]
        
        section.orthogonalScrollingBehavior = .continuous
        
        let backgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "background")
        backgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 40, leading: 0, bottom: 10, trailing: 0)
        section.decorationItems = [backgroundDecoration]
        
        return section
    }
    
    private func createVerticalSectionLayout() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let backgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "background")
        backgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        section.decorationItems = [backgroundDecoration]
        
        return section
    }
    
    private func createDefaultSectionLayout() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
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
        
        navigationItem.leftBarButtonItem = createCloseButton()
        navigationItem.rightBarButtonItem = createDeleteButton()
    }
    
    private func createCloseButton() -> UIBarButtonItem {
        let closeButton = UIButton(type: .custom)
        let xImage = UIImage(named: "x_button")
        closeButton.setImage(xImage, for: .normal)
        closeButton.addTarget(self.presenter, action: #selector(self.presenter.closeButtonTapped), for: .touchUpInside)
        
        closeButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        containerView.addSubview(closeButton)
        
        let closeBarButtonItem = UIBarButtonItem(customView: containerView)
        return closeBarButtonItem
    }
    
    private func createDeleteButton() -> UIBarButtonItem {
        let deleteButton = UIButton(type: .custom)
        let trashImage = UIImage(named: "trash")
        deleteButton.setImage(trashImage, for: .normal)
        deleteButton.addTarget(self.presenter, action: #selector(self.presenter.deleteButtonTapped), for: .touchUpInside)
        
        deleteButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        containerView.addSubview(deleteButton)
        
        let deleteBarButtonItem = UIBarButtonItem(customView: containerView)
        return deleteBarButtonItem
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
