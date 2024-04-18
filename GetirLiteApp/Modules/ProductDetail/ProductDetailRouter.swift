//
//  ProductDetailRouter.swift
//  GetirLiteApp
//
//  Created by GradByte on 17.04.2024.
//

import Foundation
import UIKit

enum ProductDetailRoutes {
    case shoppingCart, productListing
}

final class ProductDetailRouter {
    
    weak var viewController: UIViewController?
    
    static func createModule(product: Product) -> ProductDetailViewController {
        
        let interactor = ProductDetailInteractor()
        let router = ProductDetailRouter()
        let presenter = ProductDetailPresenter( router: router, interactor: interactor)
        let view = ProductDetailViewController(presenter: presenter, product: product)
        
        router.viewController = view
        interactor.output = presenter
        return view
    }
}

extension ProductDetailRouter: ProductDetailRouterProtocol {
    
    func navigate(_ route: ProductDetailRoutes) {
        switch route {
        case .shoppingCart:
            guard let window = viewController?.view.window else { return }
            let shoppingCartVC = ShoppingCartRouter.createModule()
            let navigationController = UINavigationController(rootViewController: shoppingCartVC)
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
