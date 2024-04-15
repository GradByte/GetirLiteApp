//
//  ProductListingRouter.swift
//  GetirLiteApp
//
//  Created by GradByte on 15.04.2024.
//

import Foundation
import UIKit

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
    
}
