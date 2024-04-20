//
//  ShoppingCartPresenter.swift
//  GetirLiteApp
//
//  Created by GradByte on 17.04.2024.
//

import Foundation
import UIKit

final class ShoppingCartPresenter {
    
    var suggestedProducts = [SuggestedProduct]()
    var selectedProductsArray = [(Product, Int)]()
    private let selectedProductCellIdentifier = "selectedProductCell"
    private let productCellIdentifier = "productCell"
    
    private weak var view: ShoppingCartViewController?
    private let router: ShoppingCartRouter
    private let interactor: ShoppingCartInteractor
    
    init(router: ShoppingCartRouter, interactor: ShoppingCartInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension ShoppingCartPresenter: ShoppingCartPresenterProtocol {
    func viewDidLoad(view: ShoppingCartViewController) {
        self.view = view
        self.askSelectedProducts()
        self.askFetchSuggestedProducts()
    }
    
    func askSelectedProducts() {
        self.interactor.fetchSelectedProducts()
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
    
    func routeToProductListing() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.router.navigate(.productListing, product: Product.dummy)
        }
    }
}

extension ShoppingCartPresenter: ShoppingCartInteractorOutputProtocol {
    func doneFetchSelectedProducts(selectedProducts: [(Product, Int)]) {
        self.selectedProductsArray = selectedProducts
        self.view?.getSelectedProducts()
    }
    
    func doneFetchSuggestedProducts(suggestedProducts: [SuggestedProduct]) {
        self.suggestedProducts = suggestedProducts
        self.view?.getFetchedSuggestedProducts()
    }
}


// MARK: - UICollectionViewDataSource
extension ShoppingCartPresenter {
    func numberOfSections() -> Int {
        return 3
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        if section == 0 {
            return selectedProductsArray.count
        } else if section == 1 {
            return suggestedProducts.count
        } else {
            return 0
        }
    }
    
    func cellForItemAt(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
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
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productCellIdentifier, for: indexPath) as! ProductCell
        return cell
    }
    
    func viewForSupplementaryElementOfKind(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! SectionHeaderView
            headerView.titleLabel.text = "Önerilen Ürünler"
            return headerView
        } else {
            fatalError("Unexpected element kind")
        }
    }
    
    func configureCell(_ cell: ProductCell, with product: Product) {
        if let imageURL = URL(string: product.imageURLString ?? "") {
            cell.configure(id: product.id ?? "", with: imageURL, price: ("\(product.price ?? 0.0)"), name: product.name ?? "", attribute: product.attributeString ?? "Ürün", numberOfAdded: LocalData.shared.selectedProducts[product] ?? 0)
        }
    }
}


// MARK: - UICollectionViewDelegate
extension ShoppingCartPresenter {
    func didSelectItemAt(indexPath: IndexPath) {
        if indexPath.section == 0 {
            let product = selectedProductsArray[indexPath.item].0
            self.routeToProductDetail(product: product)
            
        } else if indexPath.section == 1 {
            let product = Product(suggestedProduct: suggestedProducts[indexPath.item])
            self.routeToProductDetail(product: product)
        }
    }
}

// MARK: - Update Price
extension ShoppingCartPresenter {
    func updatePrice() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₺"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        if let formattedAmount = formatter.string(from: NSNumber(value: LocalData.shared.totalBill)) {
            self.view?.billLabel.text = formattedAmount
        }
    }
}

// MARK: - Button Actions
extension ShoppingCartPresenter: ShoppingCartPresenterObjCProtocol {
    func handlePlusButtonTap(cell: ProductCell, currentProduct: Product) {
        
        cell.borderView.layer.borderColor = GetirColor.purple.cgColor
        LocalData.shared.totalBill += currentProduct.price ?? 0.0
        
        if (LocalData.shared.selectedProducts[currentProduct] != nil) {
            LocalData.shared.selectedProducts[currentProduct]! += 1
        } else {
            cell.borderView.layer.borderColor = GetirColor.purple.cgColor
            LocalData.shared.selectedProducts[currentProduct] = 1
        }
        
        self.selectedProductsArray = LocalData.shared.selectedProducts.map { ($0.key, $0.value) }

        self.updatePrice()
        self.view?.buttonIsClicked()
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
        
        self.selectedProductsArray = LocalData.shared.selectedProducts.map { ($0.key, $0.value) }

        self.updatePrice()
        self.view?.buttonIsClicked()

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
        
        self.selectedProductsArray = LocalData.shared.selectedProducts.map { ($0.key, $0.value) }

        self.updatePrice()
        self.view?.buttonIsClicked()

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
        }
        
        self.selectedProductsArray = LocalData.shared.selectedProducts.map { ($0.key, $0.value) }

        self.updatePrice()
        self.view?.buttonIsClicked()
    }
    
    @objc func closeButtonTapped() {
        self.routeToProductListing()
    }
    
    @objc func deleteButtonTapped() {
        LocalData.shared.selectedProducts.removeAll()
        LocalData.shared.totalBill = 0.0
        
        self.askSelectedProducts()
        self.updatePrice()
        
        self.view?.collectionView.reloadData()
    }
    
    @objc func endOrderButtonTapped() {
        let alertController = UIAlertController(title: "Siparişiniz Alındı", message: "\(self.view?.billLabel.text ?? "") tutarındaki siparişinizi işleme koyduk.", preferredStyle: .alert)
            
        let confirmAction = UIAlertAction(title: "Teşekkürler", style: .default) { _ in
            LocalData.shared.selectedProducts.removeAll()
            LocalData.shared.totalBill = 0.0
            
            self.askSelectedProducts()
            self.updatePrice()
            
            self.view?.collectionView.reloadData()
            self.routeToProductListing()
        }
        
        alertController.addAction(confirmAction)
        
        self.view?.alertOnScreen(alertController: alertController)
    }
    
}
