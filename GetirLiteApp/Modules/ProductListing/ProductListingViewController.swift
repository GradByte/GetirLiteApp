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
    
    private var horizontalCollectionView: UICollectionView!
    private var verticalCollectionView: UICollectionView!
    
    private let horizontalCellIdentifier = "productCell"
    private let verticalCellIdentifier = "productCell"
    
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
        
        setupUI()
        //NetworkingManager.shared.fetchMainProducts()
        //NetworkingManager.shared.fetchSuggestedProducts()
        setupNavigationBar()
        
        setupHorizontalCollectionView()
        setupVerticalCollectionView()
        
        NetworkingManager.shared.fetchSuggestedProducts { products in
            DispatchQueue.main.async {
                if let products = products {
                    // Handle the fetched products here
                    self.suggestedProducts = products
                    self.horizontalCollectionView.reloadData()
                    // print(products)
                } else {
                    // Handle the case where products couldn't be fetched
                    print("Failed to fetch products")
                }
            }
        }
        
        NetworkingManager.shared.fetchMainProducts { products in
            DispatchQueue.main.async {
                if let products = products {
                    // Handle the fetched products here
                    self.mainProducts = products
                    self.verticalCollectionView.reloadData()
                    // print(products)
                } else {
                    // Handle the case where products couldn't be fetched
                    print("Failed to fetch products")
                }
            }
        }
    }
}

// MARK: - Setup UI Elements
extension ProductListingViewController {
    private func setupUI() {
        view.backgroundColor = GetirColor.almostWhiteGray
        setupHorizontalCollectionView()
        setupHorizontalCollectionView()
    }
    
    private func setupHorizontalCollectionView() {
        // Create a layout for the horizontal collection view
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        // Set the item size to fit one item per column
        layout.itemSize = CGSize(width: 100, height: 120) // Adjust width and height as needed
        
        // Initialize the horizontal collection view with the custom layout
        horizontalCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        horizontalCollectionView.backgroundColor = .white
        horizontalCollectionView.register(ProductCell.self, forCellWithReuseIdentifier: horizontalCellIdentifier)
        horizontalCollectionView.dataSource = self
        view.addSubview(horizontalCollectionView)
        
        // Enable horizontal scrolling
        horizontalCollectionView.isScrollEnabled = true
        
        // Add constraints for horizontal collection view
        horizontalCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            horizontalCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            horizontalCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            horizontalCollectionView.heightAnchor.constraint(equalToConstant: 140) // Adjust height as needed
        ])
    }
    
    private func setupVerticalCollectionView() {
        // Calculate the width of each item based on the available space and the number of items per row
        let itemWidth = (view.bounds.width - 30) / 3  // Subtracting 30 to account for spacing between items
        
        // Add the vertical collection view
        let verticalLayout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // Set the spacing between items
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
            
            // Calculate the group size based on the width of each item and the number of items per row
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)  // 3 items per row
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            return section
        }
        
        verticalCollectionView = UICollectionView(frame: .zero, collectionViewLayout: verticalLayout)
        verticalCollectionView.backgroundColor = .white
        verticalCollectionView.register(ProductCell.self, forCellWithReuseIdentifier: verticalCellIdentifier)
        verticalCollectionView.dataSource = self
        view.addSubview(verticalCollectionView)
        
        // Add constraints for vertical collection view
        verticalCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalCollectionView.topAnchor.constraint(equalTo: horizontalCollectionView.bottomAnchor, constant: 20),
            verticalCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            verticalCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            verticalCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
        let bagView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 36))
        bagView.backgroundColor = .white
        // Create an image view
        let imageView = UIImageView(frame: CGRect(x: (bagView.bounds.width - 15) / 2, y: (bagView.bounds.height - 15) / 2, width: 15, height: 15))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "bag.jpeg")
        // Add the image view as a subview of the white view
        bagView.addSubview(imageView)
        containerView.addSubview(bagView)
        
        // Create the billView section
        let billView = UIView(frame: CGRect(x: 30, y: 0, width: 70, height: 36))
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

extension ProductListingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == horizontalCollectionView {
            return suggestedProducts.count
        } else {
            return mainProducts.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == horizontalCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: horizontalCellIdentifier, for: indexPath) as! ProductCell
            
            let currentProduct = suggestedProducts[indexPath.row]
            
            // Convert the imageURL string to URL
            if let imageURL = URL(string: (currentProduct.imageURL ?? currentProduct.squareThumbnailURL) ?? "") {
                // Configure the cell with Kingfisher
                cell.configure(with: imageURL, price: currentProduct.priceText ?? "", name: currentProduct.name ?? "", attribute: currentProduct.shortDescription ?? "")
            } else {
                // Set a placeholder image if the imageURL string is invalid
                cell.configure(with: nil, price: currentProduct.priceText ?? "", name: currentProduct.name ?? "", attribute: currentProduct.shortDescription ?? "")
            }
            
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: verticalCellIdentifier, for: indexPath) as! ProductCell
            
            let currentProduct = mainProducts[indexPath.row]
            
            // Convert the imageURL string to URL
            if let imageURL = URL(string: currentProduct.imageURL ?? "") {
                // Configure the cell with Kingfisher
                cell.configure(with: imageURL, price: currentProduct.priceText ?? "", name: currentProduct.name ?? "", attribute: currentProduct.attribute ?? "")
            } else {
                // Set a placeholder image if the imageURL string is invalid
                cell.configure(with: nil, price: currentProduct.priceText ?? "", name: currentProduct.name ?? "", attribute: currentProduct.attribute ?? "")
            }
            
            
            return cell
        }
    }
}

extension ProductListingViewController: UICollectionViewDelegate {
    
}
