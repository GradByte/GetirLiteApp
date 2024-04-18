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
    
    private var collectionView: UICollectionView!
    private let productCellIdentifier = "productCell"
    
    //Populate these with API
    var suggestedProducts = [SuggestedProduct]()
    var selectedProductsArray = [(Product, Int)]()
    
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
        updateSelectedProductsArray()
        setupNavigationBar()
        setupCollectionView()
        fetchData()
    }
    
}

// MARK: - Setup UI elements
extension ShoppingCartViewController {
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
        LocalData.shared.selectedProducts.removeAll()
        LocalData.shared.totalBill = 0.0
        
        updateSelectedProductsArray()
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionView Data Source
extension ShoppingCartViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return selectedProductsArray.count
        } else if section == 1 {
            return suggestedProducts.count
        } else {
            return 0 // Default section has no items
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productCellIdentifier, for: indexPath) as! ProductCell
        
        if indexPath.section == 0 {
            let currentProduct = selectedProductsArray[indexPath.item].0
            configureCell(cell, with: currentProduct)
            //check if cell needs to be highlighted
            //else condition isnt required because we have prepareForReuse in place
            if LocalData.shared.selectedProducts[currentProduct] != nil {
                cell.borderView.layer.borderColor = GetirColor.purple.cgColor
            }
            
            cell.plusButtonTappedHandler = { [weak cell] in
                guard let cell = cell else { return }
                self.handlePlusButtonTap(cell: cell, currentProduct: currentProduct)
            }
            
            cell.minusButtonTappedHandler = { [weak cell] in
                guard let cell = cell else { return }
                self.handleMinusButtonTap(cell: cell, currentProduct: currentProduct)
            }
            
        } else if indexPath.section == 1 {
            let currentProduct = Product(suggestedProduct: suggestedProducts[indexPath.item])
            configureCell(cell, with: currentProduct)
            //check if cell needs to be highlighted
            //else condition isnt required because we have prepareForReuse in place
            if LocalData.shared.selectedProducts[currentProduct] != nil {
                cell.borderView.layer.borderColor = GetirColor.purple.cgColor
            }
            
            cell.plusButtonTappedHandler = { [weak cell] in
                guard let cell = cell else { return }
                self.handlePlusButtonTap(cell: cell, currentProduct: currentProduct)
            }
            
            cell.minusButtonTappedHandler = { [weak cell] in
                guard let cell = cell else { return }
                self.handleMinusButtonTap(cell: cell, currentProduct: currentProduct)
            }
        }
        
        return cell
    }
    
    // Function to handle the plus button tap event
    func handlePlusButtonTap(cell: ProductCell, currentProduct: Product) {
        // Set the border color of the cell's borderView to purple
        cell.borderView.layer.borderColor = GetirColor.purple.cgColor
        // Perform any other actions related to the plus button tap if needed
        
        LocalData.shared.totalBill += currentProduct.price ?? 0.0
        if LocalData.shared.selectedProducts.isEmpty {
            setupNavigationBar()
        }
        
        if (LocalData.shared.selectedProducts[currentProduct] != nil) {
            LocalData.shared.selectedProducts[currentProduct]! += 1
        } else {
            cell.borderView.layer.borderColor = GetirColor.purple.cgColor
            LocalData.shared.selectedProducts[currentProduct] = 1
        }
        
        updateSelectedProductsArray()
        collectionView.reloadData()
    }
    
    // Function to handle the mius button tap event
    func handleMinusButtonTap(cell: ProductCell, currentProduct: Product) {
        
        LocalData.shared.totalBill -= currentProduct.price ?? 0.0
        if LocalData.shared.selectedProducts.isEmpty {
            setupNavigationBar()
        }
        
        if (LocalData.shared.selectedProducts[currentProduct] != nil) {
            LocalData.shared.selectedProducts[currentProduct]! -= 1
            if LocalData.shared.selectedProducts[currentProduct]! == 0 {
                LocalData.shared.selectedProducts.removeValue(forKey: currentProduct)
                cell.borderView.layer.borderColor = GetirColor.almostWhiteGray.cgColor
            }
        }
        
        if LocalData.shared.selectedProducts.isEmpty {
            LocalData.shared.totalBill = 0.0
            setupNavigationBar()
        }
        
        updateSelectedProductsArray()
        collectionView.reloadData()
    }
    
    private func configureCell(_ cell: ProductCell, with product: Product) {
        
        if let imageURL = URL(string: product.imageURLString ?? "") {
            cell.configure(id: product.id ?? "", with: imageURL, price: ("\(product.price ?? 0.0)"), name: product.name ?? "", attribute: product.attributeString ?? "Ürün", numberOfAdded: LocalData.shared.selectedProducts[product] ?? 0)
        }
    }
}

// MARK: - CollectionView Delegate
extension ShoppingCartViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let product = selectedProductsArray[indexPath.item]
            
            //FIX THIS - ADD ARGUMENT
            self.presenter.routeToProductDetail()
            
        } else if indexPath.section == 1 {
            let product = Product(suggestedProduct: suggestedProducts[indexPath.row])
            
            //FIX THIS - ADD ARGUMENT
            self.presenter.routeToProductDetail()
        }
    }
}

extension ShoppingCartViewController {
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
    }
    
    private func updateSelectedProductsArray() {
        self.selectedProductsArray = LocalData.shared.selectedProducts.map { ($0.key, $0.value) }
    }
}
