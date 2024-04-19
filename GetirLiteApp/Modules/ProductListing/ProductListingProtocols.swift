//
//  ProductListingProtocols.swift
//  GetirLiteApp
//
//  Created by GradByte on 15.04.2024.
//

import Foundation

protocol ProductListingViewControllerProtocol: AnyObject {
    func getFetchedMainProducts(mainProducts: [MainProduct])
    func getFetchedSuggestedProducts(suggestedProducts: [SuggestedProduct])
}

protocol ProductListingPresenterProtocol: AnyObject {
    func viewDidLoad(view: ProductListingViewController)
    func routeToProductDetail(product: Product)
    func routeToShoppingCart(product: Product)
    
    func askFetchMainProducts()
    func askFetchSuggestedProducts()
}

protocol ProductListingInteractorInputProtocol: AnyObject {
    func fetchMainProducts()
    func fetchSuggestedProducts()
}

protocol ProductListingInteractorOutputProtocol: AnyObject {
    func doneFetchMainProducts(mainProducts: [MainProduct])
    func doneFetchSuggestedProducts(suggestedProducts: [SuggestedProduct])
}

protocol ProductListingRouterProtocol: AnyObject {
    func navigate(_ route: ProductListingRoutes, product: Product)
}
