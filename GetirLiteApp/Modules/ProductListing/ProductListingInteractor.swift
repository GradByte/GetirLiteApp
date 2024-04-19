//
//  ProductListingInteractor.swift
//  GetirLiteApp
//
//  Created by GradByte on 15.04.2024.
//

import Foundation

final class ProductListingInteractor: ProductListingInteractorInputProtocol {
    
    weak var presenter: ProductListingInteractorOutputProtocol?
    
    func fetchMainProducts() {
        NetworkingManager.shared.fetchMainProducts { products in
            DispatchQueue.main.async {
                if let products = products {
                    self.presenter?.doneFetchMainProducts(mainProducts: products)
                } else {
                    print("Failed to fetch products")
                }
            }
        }
    }
    
    func fetchSuggestedProducts() {
        NetworkingManager.shared.fetchSuggestedProducts { products in
            DispatchQueue.main.async {
                if let products = products {
                    self.presenter?.doneFetchSuggestedProducts(suggestedProducts: products)
                } else {
                    print("Failed to fetch products")
                }
            }
        }
    }
}
