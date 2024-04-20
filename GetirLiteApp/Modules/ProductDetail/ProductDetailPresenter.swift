//
//  ProductDetailPresenter.swift
//  GetirLiteApp
//
//  Created by GradByte on 17.04.2024.
//

import Foundation

final class ProductDetailPresenter {
    
    var product: Product? = nil
    var imageURL: String = ""
    var name: String = ""
    var price: String = ""
    var attribute: String = ""
    
    private weak var view: ProductDetailViewController?
    private let router: ProductDetailRouter
    private let interactor: ProductDetailInteractor
    
    init(router: ProductDetailRouter, interactor: ProductDetailInteractor, product: Product) {
        self.router = router
        self.interactor = interactor
        self.product = product
    }
}

// MARK: - Route To Other Pages
extension ProductDetailPresenter: ProductDetailPresenterProtocol {
    func viewDidLoad(view: ProductDetailViewController) {
        self.view = view
        setupValues()
        setupContent()
    }
    
    func routeToShoppingCart() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.router.navigate(.shoppingCart)
        }
    }
    
    func routeToProductListing() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.router.navigate(.productListing)
        }
    }
    
}

extension ProductDetailPresenter: ProductDetailInteractorOutputProtocol {
    
}

extension ProductDetailPresenter {
    
    func setupValues() {
        self.imageURL = product?.imageURLString ?? ""
        self.name = product?.name ?? "Ürün İsmi"
        var formattedPrice: String? {
            guard let priceString = product?.price else { return nil }
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencySymbol = "₺"
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            return formatter.string(from: NSNumber(value: priceString))
        }
        self.price = formattedPrice ?? "₺0.00"
        self.attribute = product?.attributeString ?? "Ürün"
    }
    
    func setupContent() {
        if let url = URL(string: imageURL) {
            self.view?.imageView.kf.setImage(with: url)
        }
        self.view?.nameLabel.text = name
        self.view?.priceLabel.text = price
        self.view?.attributeLabel.text = attribute
        
        self.view?.doneSetupContent()
    }
}

// MARK: - Button actions
extension ProductDetailPresenter {
    @objc func plusButtonTapped() {
        if let currentProduct = product {
            LocalData.shared.totalBill += currentProduct.price ?? 0.0
            if (LocalData.shared.selectedProducts[currentProduct] != nil) {
                LocalData.shared.selectedProducts[currentProduct]! += 1
            } else {
                LocalData.shared.selectedProducts[currentProduct] = 1
            }
        }
        
        self.view?.doneSetupContent()
    }
    
    @objc func minusButtonTapped() {
        
        if let currentProduct = product {
            LocalData.shared.totalBill -= currentProduct.price ?? 0.0
            if (LocalData.shared.selectedProducts[currentProduct] != nil) {
                LocalData.shared.selectedProducts[currentProduct]! -= 1
                if LocalData.shared.selectedProducts[currentProduct]! == 0 {
                    LocalData.shared.selectedProducts.removeValue(forKey: currentProduct)
                }
            }
        }
        
        if LocalData.shared.selectedProducts.isEmpty {
            LocalData.shared.totalBill = 0.0
        }
        
        self.view?.doneSetupContent()
    }
}


// MARK: - Navbar Button Actions
extension ProductDetailPresenter: ProductDetailPresenterObjCProtocol {
    
    @objc func closeButtonTapped() {
        self.routeToProductListing()
    }
    
    @objc func navbarBasketButtonTapped() {
        self.routeToShoppingCart()
    }
}
