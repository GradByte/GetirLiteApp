//
//  ProductListingViewController.swift
//  GetirLiteApp
//
//  Created by GradByte on 15.04.2024.
//

import Foundation
import UIKit
import Kingfisher

final class ProductListingViewController: UIViewController, ProductListingViewControllerProtocol {
    
    private var collectionView: UICollectionView!
    private let productCellIdentifier = "productCell"
    
    //Populate these with API
    var suggestedProducts = [SuggestedProduct]()
    var mainProducts = [MainProduct]()
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateBillLabel), name: Notification.Name("TotalBillUpdated"), object: nil)
        
        setupNavigationBar()
        setupUI()
        fetchData()
    }
    
    // Method to update the bill label in the navigation bar's trailing button
    @objc private func updateBillLabel() {
        setupNavigationBar()
    }
    
    // Remove observer when the view controller is deallocated
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("TotalBillUpdated"), object: nil)
    }
}

// MARK: - Setup UI Elements
extension ProductListingViewController {
    private func setupUI() {
        setupCollectionView()
    }
    
    private func fetchData() {
        NetworkingManager.shared.fetchSuggestedProducts { products in
            DispatchQueue.main.async {
                if let products = products {
                    self.suggestedProducts = products
                    self.collectionView.reloadData()
                } else {
                    print("Failed to fetch products")
                }
            }
        }
        
        NetworkingManager.shared.fetchMainProducts { products in
            DispatchQueue.main.async {
                if let products = products {
                    self.mainProducts = products
                    self.collectionView.reloadData()
                } else {
                    print("Failed to fetch products")
                }
            }
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch sectionIndex {
            case 0:
                return self.createHorizontalSectionLayout()
            case 1:
                return self.createVerticalSectionLayout()
            default:
                return self.createDefaultSectionLayout()
            }
        }
        
        layout.register(BackgroundDecorationView.self, forDecorationViewOfKind: "background")
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: productCellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.backgroundColor = GetirColor.almostWhiteGray
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    private func createHorizontalSectionLayout() -> NSCollectionLayoutSection {
        // Define item size and group size for horizontal section
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)
        
        // Ensure horizontal scrolling
        section.orthogonalScrollingBehavior = .continuous
        
        let backgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "background")
        backgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        section.decorationItems = [backgroundDecoration]
        
        return section
    }
    
    private func createVerticalSectionLayout() -> NSCollectionLayoutSection {
        // Define item size and group size for vertical section
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)
        
        let backgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "background")
        backgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        section.decorationItems = [backgroundDecoration]
        
        return section
    }
    
    private func createDefaultSectionLayout() -> NSCollectionLayoutSection {
        // Define a simple layout for default section (fallback)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
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
        title = "Ürünler"
        
        // Set the bar button item to the navigation item's rightBarButtonItem
        if LocalData.shared.totalBill > 0.0 {
            navigationItem.rightBarButtonItem = navbarBasketButton()
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem()
        }
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

// MARK: - UICollectionView Data Source
extension ProductListingViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return suggestedProducts.count // Horizontal layout
        } else if section == 1 {
            return mainProducts.count
        } else {
            return 0 // Default section has no items
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productCellIdentifier, for: indexPath) as! ProductCell
        
        if indexPath.section == 0 {
            let currentProduct = suggestedProducts[indexPath.item]
            configureCellSuggestedProduct(cell, with: currentProduct)
            //check if cell needs to be highlighted
            //else condition isnt required because we have prepareForReuse in place
            if LocalData.shared.selectedSuggestedProducts[currentProduct] != nil {
                cell.borderView.layer.borderColor = GetirColor.purple.cgColor
            }
            
            cell.plusButtonTappedHandler = { [weak cell] in
                guard let cell = cell else { return }
                self.handlePlusButtonTapSuggested(cell: cell, currentProduct: currentProduct)
            }
            
            cell.minusButtonTappedHandler = { [weak cell] in
                guard let cell = cell else { return }
                self.handleMinusButtonTapSuggested(cell: cell, currentProduct: currentProduct)
            }
            
        } else if indexPath.section == 1 {
            let currentProduct = mainProducts[indexPath.item]
            configureCellMainProduct(cell, with: currentProduct)
            //check if cell needs to be highlighted
            //else condition isnt required because we have prepareForReuse in place
            if LocalData.shared.selectedMainProducts[currentProduct] != nil {
                cell.borderView.layer.borderColor = GetirColor.purple.cgColor
            }
            
            cell.plusButtonTappedHandler = { [weak cell] in
                guard let cell = cell else { return }
                self.handlePlusButtonTapMain(cell: cell, currentProduct: currentProduct)
            }
            
            cell.minusButtonTappedHandler = { [weak cell] in
                guard let cell = cell else { return }
                self.handleMinusButtonTapMain(cell: cell, currentProduct: currentProduct)
            }
        }
        
        return cell
    }
    
    // Function to handle the plus button tap event
    func handlePlusButtonTapMain(cell: ProductCell, currentProduct: MainProduct) {
        // Set the border color of the cell's borderView to purple
        // Perform any other actions related to the plus button tap if needed
        LocalData.shared.totalBill += currentProduct.price ?? 0.0
        if LocalData.shared.selectedMainProducts.isEmpty && LocalData.shared.selectedSuggestedProducts.isEmpty {
            setupNavigationBar()
        }
        
        if (LocalData.shared.selectedMainProducts[currentProduct] != nil) {
            LocalData.shared.selectedMainProducts[currentProduct]! += 1
        } else {
            cell.borderView.layer.borderColor = GetirColor.purple.cgColor
            LocalData.shared.selectedMainProducts[currentProduct] = 1
        }
        
        collectionView.reloadData()
    }
    
    // Function to handle the plus button tap event
    func handlePlusButtonTapSuggested(cell: ProductCell, currentProduct: SuggestedProduct) {
        // Set the border color of the cell's borderView to purple
        cell.borderView.layer.borderColor = GetirColor.purple.cgColor
        // Perform any other actions related to the plus button tap if needed
        LocalData.shared.totalBill += currentProduct.price ?? 0.0
        if LocalData.shared.selectedMainProducts.isEmpty && LocalData.shared.selectedSuggestedProducts.isEmpty {
            setupNavigationBar()
        }
        
        if (LocalData.shared.selectedSuggestedProducts[currentProduct] != nil) {
            LocalData.shared.selectedSuggestedProducts[currentProduct]! += 1
        } else {
            cell.borderView.layer.borderColor = GetirColor.purple.cgColor
            LocalData.shared.selectedSuggestedProducts[currentProduct] = 1
        }
        
        collectionView.reloadData()
    }
    
    // Function to handle the mius button tap event
    func handleMinusButtonTapMain(cell: ProductCell, currentProduct: MainProduct) {
        // Set the border color of the cell's borderView to purple
        // Set the border color of the cell's borderView to purple
        // Perform any other actions related to the plus button tap if needed
        LocalData.shared.totalBill -= currentProduct.price ?? 0.0
        if LocalData.shared.selectedMainProducts.isEmpty && LocalData.shared.selectedSuggestedProducts.isEmpty {
            setupNavigationBar()
        }
        
        if (LocalData.shared.selectedMainProducts[currentProduct] != nil) {
            LocalData.shared.selectedMainProducts[currentProduct]! -= 1
            if LocalData.shared.selectedMainProducts[currentProduct]! == 0 {
                LocalData.shared.selectedMainProducts.removeValue(forKey: currentProduct)
                cell.borderView.layer.borderColor = GetirColor.almostWhiteGray.cgColor
            }
        }
        
        if LocalData.shared.selectedMainProducts.isEmpty && LocalData.shared.selectedSuggestedProducts.isEmpty {
            LocalData.shared.totalBill = 0.0
            setupNavigationBar()
        }
        
        collectionView.reloadData()
    }
    
    // Function to handle the mius button tap event
    func handleMinusButtonTapSuggested(cell: ProductCell, currentProduct: SuggestedProduct) {
        // Set the border color of the cell's borderView to purple
        // Set the border color of the cell's borderView to purple
        // Perform any other actions related to the plus button tap if needed
        LocalData.shared.totalBill -= currentProduct.price ?? 0.0
        if LocalData.shared.selectedMainProducts.isEmpty && LocalData.shared.selectedSuggestedProducts.isEmpty {
            setupNavigationBar()
        }
        
        if (LocalData.shared.selectedSuggestedProducts[currentProduct] != nil) {
            LocalData.shared.selectedSuggestedProducts[currentProduct]! -= 1
            if LocalData.shared.selectedSuggestedProducts[currentProduct]! == 0 {
                LocalData.shared.selectedSuggestedProducts.removeValue(forKey: currentProduct)
                cell.borderView.layer.borderColor = GetirColor.almostWhiteGray.cgColor
            }
        }
        
        if LocalData.shared.selectedMainProducts.isEmpty && LocalData.shared.selectedSuggestedProducts.isEmpty {
            LocalData.shared.totalBill = 0.0
            setupNavigationBar()
        }
        
        collectionView.reloadData()
    }
    
    private func configureCellMainProduct(_ cell: ProductCell, with product: MainProduct) {
        if let imageURL = URL(string: product.imageURL ?? "") {
            cell.configure(id: product.id ?? "", with: imageURL, price: product.priceText ?? "0.0", name: product.name ?? "", attribute: (product.attribute ?? product.shortDescription) ?? "Ürün", numberOfAdded: LocalData.shared.selectedMainProducts[product] ?? 0)
        } else {
            cell.configure(id: product.id ?? "", with: nil, price: product.priceText ?? "0.0", name: product.name ?? "", attribute: (product.attribute ?? product.shortDescription) ?? "Ürün", numberOfAdded: LocalData.shared.selectedMainProducts[product] ?? 0)
        }
    }
    
    private func configureCellSuggestedProduct(_ cell: ProductCell, with product: SuggestedProduct) {
        if let imageURL = URL(string: (product.imageURL ?? product.squareThumbnailURL) ?? "") {
            cell.configure(id: product.id ?? "", with: imageURL, price: product.priceText ?? "0.0", name: product.name ?? "", attribute: product.shortDescription ?? "Ürün", numberOfAdded: LocalData.shared.selectedSuggestedProducts[product] ?? 0)
        } else {
            cell.configure(id: product.id ?? "", with: nil, price: product.priceText ?? "0.0", name: product.name ?? "", attribute: product.shortDescription ?? "Ürün", numberOfAdded: LocalData.shared.selectedSuggestedProducts[product] ?? 0)
        }
    }
}

// MARK: - CollectionView Delegate
extension ProductListingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let newSuggest = suggestedProducts[indexPath.row]
            self.presenter.routeToProductDetail(suggestedProduct: newSuggest)
            
        } else if indexPath.section == 1 {
            let newMain = mainProducts[indexPath.row]
            self.presenter.routeToProductDetail(mainProduct: newMain)
        }
    }
}

class BackgroundDecorationView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white // Set the desired background color here
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
