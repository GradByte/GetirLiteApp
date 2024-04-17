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
    
    func navigate(_ route: ShoppingCartRoutes) {
        switch route {
        case .productDetail:
            guard let window = viewController?.view.window else { return }
            
            //DONT FORGET TO CHANGE THIS!
            let productDetailVC = ProductListingRouter.createModule()
            let navigationController = UINavigationController(rootViewController: productDetailVC)
            window.rootViewController = navigationController
        case .productListing:
            guard let window = viewController?.view.window else { return }
            let productListingVC = ProductListingRouter.createModule()
            let navigationController = UINavigationController(rootViewController: productListingVC)
            window.rootViewController = navigationController
        }
    }
    
}
