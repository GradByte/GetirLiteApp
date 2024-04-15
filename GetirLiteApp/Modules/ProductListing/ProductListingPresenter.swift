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

extension ProductListingPresenter: ProductListingInteractorOutputProtocol {
    
}
