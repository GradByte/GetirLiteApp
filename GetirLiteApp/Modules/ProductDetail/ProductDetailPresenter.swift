//
//  ProductDetailPresenter.swift
//  GetirLiteApp
//
//  Created by GradByte on 17.04.2024.
//

import Foundation

final class ProductDetailPresenter: ProductDetailPresenterProtocol {
    
    private weak var view: ProductDetailViewController?
    private let router: ProductDetailRouter
    private let interactor: ProductDetailInteractor
    
    init(router: ProductDetailRouter, interactor: ProductDetailInteractor) {
        self.router = router
        self.interactor = interactor
    }
    
    func viewDidLoad(view: ProductDetailViewController) {
        self.view = view
    }
    
}

// MARK: - Route To Other Pages
extension ProductDetailPresenter {
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
