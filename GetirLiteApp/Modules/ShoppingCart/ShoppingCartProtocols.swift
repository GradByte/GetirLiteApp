//
//  ShoppingCartProtocols.swift
//  GetirLiteApp
//
//  Created by GradByte on 17.04.2024.
//

import Foundation

protocol ShoppingCartViewControllerProtocol: AnyObject {
    
    func getSelectedProducts()
    func getFetchedSuggestedProducts()
}

protocol ShoppingCartPresenterProtocol: AnyObject {
    func viewDidLoad(view: ShoppingCartViewController)
    
    func askSelectedProducts()
    func askFetchSuggestedProducts()
    
    func routeToProductDetail(product: Product)
    func routeToProductListing()
}

protocol ShoppingCartInteractorInputProtocol: AnyObject {
    
    func fetchSelectedProducts()
    func fetchSuggestedProducts()
}

protocol ShoppingCartInteractorOutputProtocol: AnyObject {
    
    func doneFetchSelectedProducts(selectedProducts: [(Product, Int)])
    func doneFetchSuggestedProducts(suggestedProducts: [SuggestedProduct])
}

protocol ShoppingCartRouterProtocol: AnyObject {
    
    func navigate(_ route: ShoppingCartRoutes, product: Product)
}
