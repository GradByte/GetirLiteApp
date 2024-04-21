//
//  RouterTests.swift
//  GetirLiteAppTests
//
//  Created by GradByte on 21.04.2024.
//

import XCTest
@testable import GetirLiteApp

final class RouterTests: XCTestCase {
    
    func testNavigateToProductDetailFromListing() {
        let expectation = XCTestExpectation(description: "SuggestedProduct created successfully")
        
        let router = ProductListingRouter()
        let mockViewController = UIViewController()
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: mockViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        router.viewController = mockViewController
        
        router.navigate(.productDetail, product: Product.dummy)
        
        XCTAssertTrue(navigationController.children.count == 1)
        
        expectation.fulfill()
    }
    
    func testNavigateToProductDetailFromCart() {
        let expectation = XCTestExpectation(description: "SuggestedProduct created successfully")
        
        let router = ShoppingCartRouter()
        let mockViewController = UIViewController()
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: mockViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        router.viewController = mockViewController
        
        router.navigate(.productDetail, product: Product.dummy)
        
        XCTAssertTrue(navigationController.children.count == 1)
        
        expectation.fulfill()
    }
    
    func testNavigateToCartFromListing() {
        let expectation = XCTestExpectation(description: "SuggestedProduct created successfully")
        
        let router = ProductListingRouter()
        let mockViewController = UIViewController()
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: mockViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        router.viewController = mockViewController
        
        router.navigate(.shoppingCart, product: Product.dummy)
        
        XCTAssertTrue(navigationController.children.count == 1)
        
        expectation.fulfill()
    }
    
    func testNavigateToCartFromDetail() {
        let expectation = XCTestExpectation(description: "SuggestedProduct created successfully")
        
        let router = ProductDetailRouter()
        let mockViewController = UIViewController()
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: mockViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        router.viewController = mockViewController
        
        router.navigate(.shoppingCart)
        
        XCTAssertTrue(navigationController.children.count == 1)
        
        expectation.fulfill()
    }
    
    func testNavigateToListingFromDetail() {
        let expectation = XCTestExpectation(description: "SuggestedProduct created successfully")
        
        let router = ProductDetailRouter()
        let mockViewController = UIViewController()
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: mockViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        router.viewController = mockViewController
        
        router.navigate(.productListing)
        
        XCTAssertTrue(navigationController.children.count == 1)
        
        expectation.fulfill()
    }
    
    func testNavigateToListingFromCart() {
        let expectation = XCTestExpectation(description: "SuggestedProduct created successfully")
        
        let router = ShoppingCartRouter()
        let mockViewController = UIViewController()
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: mockViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        router.viewController = mockViewController
        
        router.navigate(.productListing, product: Product.dummy)
        
        XCTAssertTrue(navigationController.children.count == 1)
        
        expectation.fulfill()
    }
}
