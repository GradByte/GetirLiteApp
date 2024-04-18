//
//  ShoppingCartRouter.swift
//  GetirLiteApp
//
//  Created by GradByte on 17.04.2024.
//

import Foundation
import UIKit

enum ShoppingCartRoutes {
    case productDetail, productListing
}

final class ShoppingCartRouter {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> ShoppingCartViewController {
        
        let interactor = ShoppingCartInteractor()
        let router = ShoppingCartRouter()
        let presenter = ShoppingCartPresenter( router: router, interactor: interactor)
        let view = ShoppingCartViewController(presenter: presenter)
        
        router.viewController = view
        interactor.output = presenter
        return view
    }
}

extension ShoppingCartRouter: ShoppingCartRouterProtocol {
    
    func navigate(_ route: ShoppingCartRoutes, product: Product) {
        switch route {
        case .productDetail:
            guard let window = viewController?.view.window else { return }
            let productDetailVC = ProductDetailRouter.createModule(product: product)
            let navigationController = UINavigationController(rootViewController: productDetailVC)
            UIView.transition(with: window, duration: 0.5, options: .curveEaseInOut, animations: {
                        window.rootViewController = navigationController
                    }, completion: nil)
        case .productListing:
            guard let window = viewController?.view.window else { return }
            let productListingVC = ProductListingRouter.createModule()
            let navigationController = UINavigationController(rootViewController: productListingVC)
            UIView.transition(with: window, duration: 0.5, options: .transitionCurlUp, animations: {
                        window.rootViewController = navigationController
                    }, completion: nil)
        }
    }
    
}
