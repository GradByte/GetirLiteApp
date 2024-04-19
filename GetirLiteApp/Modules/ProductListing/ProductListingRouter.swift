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
        interactor.presenter = presenter
        return view
    }
}

extension ProductListingRouter: ProductListingRouterProtocol {
    
    func navigate(_ route: ProductListingRoutes, product: Product) {
        switch route {
        case .productDetail:
            guard let window = viewController?.view.window else { return }
            let productDetailVC = ProductDetailRouter.createModule(product: product)
            let navigationController = UINavigationController(rootViewController: productDetailVC)
            UIView.transition(with: window, duration: 0.5, options: .curveEaseInOut, animations: {
                        window.rootViewController = navigationController
                    }, completion: nil)
        case .shoppingCart:
            guard let window = viewController?.view.window else { return }
            let shoppingCartVC = ShoppingCartRouter.createModule()
            let navigationController = UINavigationController(rootViewController: shoppingCartVC)
            UIView.transition(with: window, duration: 0.5, options: .curveEaseInOut, animations: {
                        window.rootViewController = navigationController
                    }, completion: nil)
        }
    }
    
}
