//
//  ProductListingPresenter.swift
//  GetirLiteApp
//
//  Created by GradByte on 15.04.2024.
//

import Foundation

final class ProductListingPresenter {
    
    private weak var view: ProductListingViewController?
    private let router: ProductListingRouter
    private let interactor: ProductListingInteractor
    
    
    var suggestedProducts = [SuggestedProduct]()
    var mainProducts = [MainProduct]()
    
    
    init(router: ProductListingRouter, interactor: ProductListingInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension ProductListingPresenter: ProductListingPresenterProtocol {
    
    func viewDidLoad(view: ProductListingViewController) {
        self.view = view
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
    
    func askFetchMainProducts() {
        self.interactor.fetchMainProducts()
    }
    
    func askFetchSuggestedProducts() {
        self.interactor.fetchSuggestedProducts()
    }
}

extension ProductListingPresenter: ProductListingInteractorOutputProtocol {
    
    func doneFetchMainProducts(mainProducts: [MainProduct]) {
        self.mainProducts = mainProducts
        self.view?.getFetchedMainProducts(mainProducts: mainProducts)
    }
    
    func doneFetchSuggestedProducts(suggestedProducts: [SuggestedProduct]) {
        self.suggestedProducts = suggestedProducts
        self.view?.getFetchedSuggestedProducts(suggestedProducts: suggestedProducts)
    }
}
