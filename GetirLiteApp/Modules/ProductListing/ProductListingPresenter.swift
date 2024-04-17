//
//  ProductListingPresenter.swift
//  GetirLiteApp
//
//  Created by GradByte on 15.04.2024.
//

import Foundation

final class ProductListingPresenter: ProductListingPresenterProtocol {
    
    private weak var view: ProductListingViewController?
    private let router: ProductListingRouter
    private let interactor: ProductListingInteractor
    
    init(router: ProductListingRouter, interactor: ProductListingInteractor) {
        self.router = router
        self.interactor = interactor
    }
    
    func viewDidLoad(view: ProductListingViewController) {
        self.view = view
    }
    
}

// MARK: - Route To Other Pages
extension ProductListingPresenter {
    func routeToProductDetail(mainProduct: MainProduct? = nil, suggestedProduct: SuggestedProduct? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.router.navigate(.productDetail, mainProduct: mainProduct, suggestedProduct: suggestedProduct)
        }
    }
    
    func routeToShoppingCart() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.router.navigate(.shoppingCart)
        }
    }
}

extension ProductListingPresenter: ProductListingInteractorOutputProtocol {
    
}
