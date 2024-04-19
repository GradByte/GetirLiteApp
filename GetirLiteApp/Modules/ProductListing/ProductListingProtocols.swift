//
//  ProductListingProtocols.swift
//  GetirLiteApp
//
//  Created by GradByte on 15.04.2024.
//

import Foundation
import UIKit

protocol ProductListingViewControllerProtocol: AnyObject {
    
    // Get Fetched Products
    func getFetchedMainProducts()
    func getFetchedSuggestedProducts()
}

protocol ProductListingPresenterProtocol: AnyObject {
    func viewDidLoad(view: ProductListingViewController)
    
    // Ask Fetch Products
    func askFetchMainProducts()
    func askFetchSuggestedProducts()
    
    // UIViewCollection Data Source & Delegate
    func numberOfSections() -> Int
    func numberOfItemsInSection(section: Int) -> Int
    func cellForItemAt(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    func configureCell(_ cell: ProductCell, with product: Product)
    func didSelectItemAt(indexPath: IndexPath)
    
    // Button Actions
    func handlePlusButtonTap(cell: ProductCell, currentProduct: Product)
    func handleMinusButtonTap(cell: ProductCell, currentProduct: Product)
    func navbarBasketButtonTapped()
    
    // Routing
    func routeToProductDetail(product: Product)
    func routeToShoppingCart(product: Product)
}

protocol ProductListingInteractorInputProtocol: AnyObject {
    
    // Fetch Products
    func fetchMainProducts()
    func fetchSuggestedProducts()
}

protocol ProductListingInteractorOutputProtocol: AnyObject {
    
    // Products are fetched
    func doneFetchMainProducts(mainProducts: [MainProduct])
    func doneFetchSuggestedProducts(suggestedProducts: [SuggestedProduct])
}

protocol ProductListingRouterProtocol: AnyObject {
    
    // Routing
    func navigate(_ route: ProductListingRoutes, product: Product)
}
