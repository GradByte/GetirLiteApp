//
//  ProductListingPresenter.swift
//  GetirLiteApp
//
//  Created by GradByte on 15.04.2024.
//

import Foundation
import UIKit

final class ProductListingPresenter {
    
    private weak var view: ProductListingViewController?
    private let router: ProductListingRouter
    private let interactor: ProductListingInteractor
    
    
    var suggestedProducts = [SuggestedProduct]()
    var mainProducts = [MainProduct]()
    private let productCellIdentifier = "productCell"
    
    
    init(router: ProductListingRouter, interactor: ProductListingInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension ProductListingPresenter: ProductListingPresenterProtocol {
    
    func viewDidLoad(view: ProductListingViewController) {
        self.view = view
        self.askFetchMainProducts()
        self.askFetchSuggestedProducts()
    }
    
    func askFetchMainProducts() {
        self.interactor.fetchMainProducts()
    }
    
    func askFetchSuggestedProducts() {
        self.interactor.fetchSuggestedProducts()
    }
    
    func routeToProductDetail(product: Product) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.router.navigate(.productDetail, product: product)
        }
    }
    
    func routeToShoppingCart(product: Product) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.router.navigate(.shoppingCart, product: product)
        }
    }
}

extension ProductListingPresenter: ProductListingInteractorOutputProtocol {
    
    func doneFetchMainProducts(mainProducts: [MainProduct]) {
        self.mainProducts = mainProducts
        self.view?.getFetchedMainProducts()
    }
    
    func doneFetchSuggestedProducts(suggestedProducts: [SuggestedProduct]) {
        self.suggestedProducts = suggestedProducts
        self.view?.getFetchedSuggestedProducts()
    }
}

// MARK: - UICollectionViewDataSource
extension ProductListingPresenter {
    func numberOfSections() -> Int {
        return 3
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        if section == 0 {
            return suggestedProducts.count
        } else if section == 1 {
            return mainProducts.count
        } else {
            return 0
        }
    }
    
    func cellForItemAt(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productCellIdentifier, for: indexPath) as! ProductCell
        
        if indexPath.section == 0 {
            let currentProduct = Product(suggestedProduct: suggestedProducts[indexPath.item])
            configureCell(cell, with: currentProduct)
            
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
            let currentProduct = Product(mainProduct: mainProducts[indexPath.item])
            configureCell(cell, with: currentProduct)
            
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
    
    func configureCell(_ cell: ProductCell, with product: Product) {
        if let imageURL = URL(string: product.imageURLString ?? "") {
            cell.configure(id: product.id ?? "", with: imageURL, price: ("\(product.price ?? 0.0)"), name: product.name ?? "", attribute: product.attributeString ?? "Ürün", numberOfAdded: LocalData.shared.selectedProducts[product] ?? 0)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ProductListingPresenter {
    func didSelectItemAt(indexPath: IndexPath) {
        if indexPath.section == 0 {
            let newSuggest = Product(suggestedProduct: suggestedProducts[indexPath.row])
            self.routeToProductDetail(product: newSuggest)
            
        } else if indexPath.section == 1 {
            let newMain = Product(mainProduct: mainProducts[indexPath.row])
            self.routeToProductDetail(product: newMain)
        }
    }
}

// MARK: - Button Actions
extension ProductListingPresenter {

    func handlePlusButtonTap(cell: ProductCell, currentProduct: Product) {

        cell.borderView.layer.borderColor = GetirColor.purple.cgColor
        
        LocalData.shared.totalBill += currentProduct.price ?? 0.0
        if LocalData.shared.selectedProducts.isEmpty {
            self.view?.setupNavigationBar()
        }
        
        if (LocalData.shared.selectedProducts[currentProduct] != nil) {
            LocalData.shared.selectedProducts[currentProduct]! += 1
        } else {
            cell.borderView.layer.borderColor = GetirColor.purple.cgColor
            LocalData.shared.selectedProducts[currentProduct] = 1
        }
        
        self.view?.setupNavigationBar()
        self.view?.collectionView.reloadData()
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
        }
        
        self.view?.setupNavigationBar()
        self.view?.collectionView.reloadData()
    }
    
    @objc func navbarBasketButtonTapped() {
        self.routeToShoppingCart(product: Product.dummy)
    }
}
