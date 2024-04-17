//
//  ProductListingRouter.swift
//  GetirLiteApp
//
//  Created by GradByte on 15.04.2024.
//

import Foundation
import UIKit

enum ProductListingRoutes {
    case productDetail, shoppingCart
}

final class ProductListingRouter {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> ProductListingViewController {
        
        let interactor = ProductListingInteractor()
        let router = ProductListingRouter()
        let presenter = ProductListingPresenter( router: router, interactor: interactor)
        let view = ProductListingViewController(presenter: presenter)
        
        router.viewController = view
        interactor.output = presenter
        return view
    }
}

extension ProductListingRouter: ProductListingRouterProtocol {
    
    func navigate(_ route: ProductListingRoutes) {
        switch route {
        case .productDetail:
            guard let window = viewController?.view.window else { return }
            let productDetailVC = ProductDetailRouter.createModule()
            let navigationController = UINavigationController(rootViewController: productDetailVC)
            window.rootViewController = navigationController
        case .shoppingCart:
            guard let window = viewController?.view.window else { return }
            let shoppingCartVC = ShoppingCartRouter.createModule()
            let navigationController = UINavigationController(rootViewController: shoppingCartVC)
            window.rootViewController = navigationController
        }
    }
    
}
