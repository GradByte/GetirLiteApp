//
//  ProductDetailProtocols.swift
//  GetirLiteApp
//
//  Created by GradByte on 17.04.2024.
//

import Foundation

protocol ProductDetailViewControllerProtocol: AnyObject {
    
    // Refresh page
    func doneSetupContent()
}

protocol ProductDetailPresenterProtocol: AnyObject {
    func viewDidLoad(view: ProductDetailViewController)
    
    // Routing
    func routeToShoppingCart()
    func routeToProductListing()
    
    // Setup variables
    func setupValues()
    func setupContent()
    
    // Button actions
    func plusButtonTapped()
    func minusButtonTapped()
}

@objc protocol ProductDetailPresenterObjCProtocol: AnyObject {
    
    // Navbar button actions
    func closeButtonTapped()
    func navbarBasketButtonTapped()
}

protocol ProductDetailInteractorInputProtocol: AnyObject {
    
}

protocol ProductDetailInteractorOutputProtocol: AnyObject {
    
}

protocol ProductDetailRouterProtocol: AnyObject {
    
    // Routing
    func navigate(_ route: ProductDetailRoutes)
}

