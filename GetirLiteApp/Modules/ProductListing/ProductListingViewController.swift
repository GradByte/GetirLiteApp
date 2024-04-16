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
    
    var suggestedProducts = [Product]()
    var mainProducts = [ProductElement]()
    
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
        
        setupNavigationBar()
        setupUI()
        fetchData()
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
        navigationItem.rightBarButtonItem = navbarBasketButton()
        
    }
    
    private func navbarBasketButton() -> UIBarButtonItem {
        
        // Create a container view to hold the custom button
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 36))
        
        // Create the bagView section
        let bagView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        bagView.backgroundColor = .white
        // Create an image view
        let imageView = UIImageView(frame: CGRect(x: (bagView.bounds.width - 32) / 2, y: (bagView.bounds.height - 32) / 2, width: 32, height: 32))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "bag1")
        // Add the image view as a subview of the white view
        bagView.addSubview(imageView)
        containerView.addSubview(bagView)
        
        // Create the billView section
        let billView = UIView(frame: CGRect(x: 36, y: 0, width: 64, height: 36))
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
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        
        // Create a bar button item with the container view
        let customButton = UIBarButtonItem(customView: containerView)
        return customButton
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
            configureCellProduct(cell, with: currentProduct)
        } else if indexPath.section == 1 {
            let currentProduct = mainProducts[indexPath.item]
            configureCellProductElement(cell, with: currentProduct)
        }
        
        return cell
    }
    
    private func configureCellProduct(_ cell: ProductCell, with product: Product) {
        if let imageURL = URL(string: (product.imageURL ?? product.squareThumbnailURL) ?? "") {
            cell.configure(with: imageURL, price: product.priceText ?? "", name: product.name ?? "", attribute: product.shortDescription ?? "")
        } else {
            cell.configure(with: nil, price: product.priceText ?? "", name: product.name ?? "", attribute: product.shortDescription ?? "")
        }
    }
    
    private func configureCellProductElement(_ cell: ProductCell, with product: ProductElement) {
        if let imageURL = URL(string: product.imageURL ?? "") {
            cell.configure(with: imageURL, price: product.priceText ?? "", name: product.name ?? "", attribute: product.attribute ?? "")
        } else {
            cell.configure(with: nil, price: product.priceText ?? "", name: product.name ?? "", attribute: product.attribute ?? "")
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
