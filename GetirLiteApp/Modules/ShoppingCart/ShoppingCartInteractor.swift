//
//  ShoppingCartInteractor.swift
//  GetirLiteApp
//
//  Created by GradByte on 17.04.2024.
//

import Foundation

final class ShoppingCartInteractor: ShoppingCartInteractorInputProtocol {
    
    weak var presenter: ShoppingCartInteractorOutputProtocol?
    
    var selectedProductsArray = [(Product, Int)]()
    
    func fetchSelectedProducts() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            selectedProductsArray = LocalData.shared.selectedProducts.map { ($0.key, $0.value) }
            self.presenter?.doneFetchSelectedProducts(selectedProducts: selectedProductsArray)
        }
    }
    
    func fetchSuggestedProducts() {
        NetworkingManager.shared.fetchSuggestedProducts { products in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                if let products = products {
                    self.presenter?.doneFetchSuggestedProducts(suggestedProducts: products)
                } else {
                    print("Failed to fetch products")
                }
            }
        }
    }
}
