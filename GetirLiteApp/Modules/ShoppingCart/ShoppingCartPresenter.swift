//
//  ShoppingCartPresenter.swift
//  GetirLiteApp
//
//  Created by GradByte on 17.04.2024.
//

import Foundation

final class ShoppingCartPresenter: ShoppingCartPresenterProtocol {
    
    private weak var view: ShoppingCartViewController?
    private let router: ShoppingCartRouter
    private let interactor: ShoppingCartInteractor
    
    init(router: ShoppingCartRouter, interactor: ShoppingCartInteractor) {
        self.router = router
        self.interactor = interactor
    }
    
    func viewDidLoad(view: ShoppingCartViewController) {
        self.view = view
    }
    
}

// MARK: - Route To Other Pages
extension ShoppingCartPresenter {
    func routeToProductDetail() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.router.navigate(.productDetail)
        }
    }
    
    func routeToProductListing() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.router.navigate(.productListing)
        }
    }
}

extension ShoppingCartPresenter: ShoppingCartInteractorOutputProtocol {
    
}
