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
        view.backgroundColor = .white
        view.addSubview(defaultAddButton)
        
        defaultAddButton.addArrangedSubview(buttonLabel)
        defaultAddButton.addArrangedSubview(billLabel)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(endOrderButtonTapped))
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

    private func updatePrice() {
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
    
    private func placeOrder() {
        // Here you can perform actions to place the order
        // For example, you can navigate to the listing view controller after placing the order
        self.presenter.routeToProductListing()
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! SectionHeaderView
            headerView.titleLabel.text = "Önerilen Ürünler"
            return headerView
        } else {
            fatalError("Unexpected element kind")
        }
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

// MARK: - Button Actions
extension ShoppingCartViewController {

    func handlePlusButtonTap(cell: ProductCell, currentProduct: Product) {
        
        cell.borderView.layer.borderColor = GetirColor.purple.cgColor
        LocalData.shared.totalBill += currentProduct.price ?? 0.0
        
        if (LocalData.shared.selectedProducts[currentProduct] != nil) {
            LocalData.shared.selectedProducts[currentProduct]! += 1
        } else {
            cell.borderView.layer.borderColor = GetirColor.purple.cgColor
            LocalData.shared.selectedProducts[currentProduct] = 1
        }
        
        updateSelectedProductsArray()
        updatePrice()
        collectionView.reloadData()
    }
    
    func handleMinusButtonTap(cell: ProductCell, currentProduct: Product) {
        
        LocalData.shared.totalBill -= currentProduct.price ?? 0.0
        
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
        updatePrice()
        collectionView.reloadData()
    }
    
    func handlePlusButtonTapSelected(cell: SelectedProductCell, currentProduct: Product) {

        cell.borderView.layer.borderColor = GetirColor.purple.cgColor
        LocalData.shared.totalBill += currentProduct.price ?? 0.0
        
        if (LocalData.shared.selectedProducts[currentProduct] != nil) {
            LocalData.shared.selectedProducts[currentProduct]! += 1
        } else {
            cell.borderView.layer.borderColor = GetirColor.purple.cgColor
            LocalData.shared.selectedProducts[currentProduct] = 1
        }
        
        updateSelectedProductsArray()
        updatePrice()
        collectionView.reloadData()
    }
    
    func handleMinusButtonTapSelected(cell: SelectedProductCell, currentProduct: Product) {
        
        LocalData.shared.totalBill -= currentProduct.price ?? 0.0
        
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
        updatePrice()
        collectionView.reloadData()
    }
    
    @objc func closeButtonTapped() {
        self.presenter.routeToProductListing()
    }
    
    @objc func deleteButtonTapped() {
        LocalData.shared.selectedProducts.removeAll()
        LocalData.shared.totalBill = 0.0
        
        updateSelectedProductsArray()
        updatePrice()

        self.collectionView.reloadData()
    }
    
    @objc func endOrderButtonTapped() {
        let alertController = UIAlertController(title: "Onay", message: "Siparişi onaylıyor musunuz?", preferredStyle: .alert)
            
        let cancelAction = UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Evet", style: .default) { _ in
            LocalData.shared.selectedProducts.removeAll()
            LocalData.shared.totalBill = 0.0
            
            self.updateSelectedProductsArray()
            self.updatePrice()
            
            self.collectionView.reloadData()
            self.placeOrder()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
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
}
