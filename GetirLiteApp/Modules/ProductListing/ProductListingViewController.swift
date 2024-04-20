//
//  ProductListingViewController.swift
//  GetirLiteApp
//
//  Created by GradByte on 15.04.2024.
//

import Foundation
import UIKit
import Kingfisher

final class ProductListingViewController: UIViewController {
    
    private let productCellIdentifier = "productCell"
    
    var collectionView: UICollectionView!
    
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
    }
}

extension ProductListingViewController: ProductListingViewControllerProtocol {
    func getFetchedMainProducts() {
        self.collectionView.reloadData()
    }
    
    func getFetchedSuggestedProducts() {
        self.collectionView.reloadData()
    }
}

// MARK: - Setup UI Elements
extension ProductListingViewController {
    func setupUI() {
        setupNavigationBar()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch sectionIndex {
            case 0:
                return LayoutItems.shared.createHorizontalSectionLayout()
            case 1:
                return LayoutItems.shared.createVerticalSectionLayoutForListing()
            default:
                return LayoutItems.shared.createDefaultSectionLayout()
            }
        }
        layout.register(BackgroundDecorationView.self, forDecorationViewOfKind: "background")
                
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = GetirColor.almostWhiteGray
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: productCellIdentifier)
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
        title = "Ürünler"
        
        if LocalData.shared.totalBill > 0.0 {
            navigationItem.rightBarButtonItem = NavbarItems.shared.navbarBasketButton(listingPagePresenter: self.presenter)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem()
        }
    }
}

// MARK: - UICollectionView Data Source
extension ProductListingViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.presenter.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.presenter.numberOfItemsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.presenter.cellForItemAt(collectionView: collectionView, indexPath: indexPath)
    }
}

// MARK: - UICollectionView Delegate
extension ProductListingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter.didSelectItemAt(indexPath: indexPath)
    }
}
