//
//  ShoppingCartProtocols.swift
//  GetirLiteApp
//
//  Created by GradByte on 17.04.2024.
//

import Foundation
import UIKit

protocol ShoppingCartViewControllerProtocol: AnyObject {
    
    // Refresh page
    func getSelectedProducts()
    func getFetchedSuggestedProducts()
    func buttonIsClicked()
}

protocol ShoppingCartPresenterProtocol: AnyObject {
    func viewDidLoad(view: ShoppingCartViewController)
    
    // Ask products
    func askSelectedProducts()
    func askFetchSuggestedProducts()
    
    // Routing
    func routeToProductDetail(product: Product)
    func routeToProductListing()
    
    // UICollectionView Data Source & Delegate
    func numberOfSections() -> Int
    func numberOfItemsInSection(section: Int) -> Int
    func cellForItemAt(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    func viewForSupplementaryElementOfKind(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    func configureCell(_ cell: ProductCell, with product: Product)
    func didSelectItemAt(indexPath: IndexPath)
    
    // Button actions
    func handlePlusButtonTap(cell: ProductCell, currentProduct: Product)
    func handleMinusButtonTap(cell: ProductCell, currentProduct: Product)
    func handlePlusButtonTapSelected(cell: SelectedProductCell, currentProduct: Product)
    func handleMinusButtonTapSelected(cell: SelectedProductCell, currentProduct: Product)
    func endOrderButtonTapped()
}

@objc protocol ShoppingCartPresenterObjCProtocol: AnyObject {
    
    // Navbar button actions
    func closeButtonTapped()
    func deleteButtonTapped()
}

protocol ShoppingCartInteractorInputProtocol: AnyObject {
    
    // Fetch products
    func fetchSelectedProducts()
    func fetchSuggestedProducts()
}

protocol ShoppingCartInteractorOutputProtocol: AnyObject {
    
    // Fetching is done
    func doneFetchSelectedProducts(selectedProducts: [(Product, Int)])
    func doneFetchSuggestedProducts(suggestedProducts: [SuggestedProduct])
}

protocol ShoppingCartRouterProtocol: AnyObject {
    
    // Routing
    func navigate(_ route: ShoppingCartRoutes, product: Product)
}
