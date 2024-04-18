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
    private let selectedProductCellIdentifier = "selectedProductCell"
    private let productCellIdentifier = "productCell"
    
    //Populate these with API
    var suggestedProducts = [SuggestedProduct]()
    var selectedProductsArray = [(Product, Int)]()
    
    private let defaultAddButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sepete Ekle", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.backgroundColor = GetirColor.purple
        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        // button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
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
        updateSelectedProductsArray()

        setupNavigationBar()
        setupUI()

        setupCollectionView()
        fetchData()
    }
    
}

// MARK: - Setup UI elements
extension ShoppingCartViewController {
    private func setupUI() {
        view.addSubview(defaultAddButton)
        view.backgroundColor = .white
        
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
        // Define item size and group size for horizontal section
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
        
        // Ensure horizontal scrolling
        section.orthogonalScrollingBehavior = .continuous
        
        let backgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "background")
        backgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 40, leading: 0, bottom: 10, trailing: 0)
        section.decorationItems = [backgroundDecoration]
        
        return section
    }
    
    private func createVerticalSectionLayout() -> NSCollectionLayoutSection {
        // Define item size and group size for vertical section
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
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: selectedProductCellIdentifier, for: indexPath) as! SelectedProductCell
            
            let (product, quantity) = selectedProductsArray[indexPath.item]
            cell.configure(id: product.id ?? "", with: URL(string: product.imageURLString ?? ""), price: "\(product.price ?? 0.0)", name: product.name ?? "", attribute: product.attributeString ?? "Ürün", numberOfAdded: quantity)
            
            cell.plusButtonTappedHandler = { [weak self] in
                self?.handlePlusButtonTapSelected(cell: cell, currentProduct: product)
            }
            
            cell.minusButtonTappedHandler = { [weak self] in
                self?.handleMinusButtonTapSelected(cell: cell, currentProduct: product)
            }
            
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productCellIdentifier, for: indexPath) as! ProductCell
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
            
            return cell
        } else {
            // Return other cells for other sections
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productCellIdentifier, for: indexPath) as! ProductCell
            return cell
        }
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
    
    // Function to handle the plus button tap event
    func handlePlusButtonTapSelected(cell: SelectedProductCell, currentProduct: Product) {
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
    func handleMinusButtonTapSelected(cell: SelectedProductCell, currentProduct: Product) {
        
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
            let product = selectedProductsArray[indexPath.item].0
            self.presenter.routeToProductDetail(product: product)
            
        } else if indexPath.section == 1 {
            let product = Product(suggestedProduct: suggestedProducts[indexPath.row])
            self.presenter.routeToProductDetail(product: product)
        }
    }
}

extension ShoppingCartViewController {
    private func fetchData() {
        if LocalData.shared.downloadedSuggestedProducts.isEmpty {
            NetworkingManager.shared.fetchSuggestedProducts { products in
                DispatchQueue.main.async {
                    if let products = products {
                        self.suggestedProducts = products
                        LocalData.shared.downloadedSuggestedProducts = products
                        self.collectionView.reloadData()
                    } else {
                        print("Failed to fetch products")
                    }
                }
            }
        } else {
            self.suggestedProducts = LocalData.shared.downloadedSuggestedProducts
        }
    }
    
    private func updateSelectedProductsArray() {
        self.selectedProductsArray = LocalData.shared.selectedProducts.map { ($0.key, $0.value) }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! SectionHeaderView
                headerView.titleLabel.text = "Önerilen Ürünler"
                return headerView
            } else {
                fatalError("Unexpected element kind")
            }
        }
}

class SectionHeaderView: UICollectionReusableView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
