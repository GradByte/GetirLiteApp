//
//  ViewControllerTests.swift
//  GetirLiteAppTests
//
//  Created by GradByte on 21.04.2024.
//

import XCTest
@testable import GetirLiteApp

final class ViewControllerTests: XCTestCase {
    
    // Product Listing View Controller (PLVC)
    func testPLVCUpdateWithProducts() {
        let expectation = XCTestExpectation(description: "Products stored successfully")
        
        let mockInteractor = ProductListingInteractor()
        let mockRouter = ProductListingRouter()
        let mockPresenter = ProductListingPresenter(router: mockRouter, interactor: mockInteractor)
        let mockView = ProductListingViewController(presenter: mockPresenter)
        mockInteractor.presenter = mockPresenter
        
        
        let testMainProduct = MainProduct(id: "", name: "", attribute: "", thumbnailURL: "", imageURL: "", price: 0.0, priceText: "", shortDescription: "")
        let testSuggestedProduct = SuggestedProduct(id: "", imageURL: "", price: 0.0, name: "", priceText: "", shortDescription: "", category: "", unitPrice: 0.0, squareThumbnailURL: "", status: 0)
        mockPresenter.mainProducts.append(testMainProduct)
        mockPresenter.suggestedProducts.append(testSuggestedProduct)
        
        
        mockView.viewDidLoad()

        
        XCTAssertTrue(mockView.collectionView.numberOfItems(inSection: 0) == 1)
        XCTAssertTrue(mockView.collectionView.numberOfItems(inSection: 1) == 1)
        expectation.fulfill()
    }
    
    // Product Detail View Controller (PDVC)
    func testPDVCUpdateWithProducts() {
        let expectation = XCTestExpectation(description: "Products stored successfully")
        
        let mockInteractor = ProductDetailInteractor()
        let mockRouter = ProductDetailRouter()
        let mockPresenter = ProductDetailPresenter(router: mockRouter, interactor: mockInteractor, product: Product.dummy)
        let mockView = ProductDetailViewController(presenter: mockPresenter)
        
        
        mockView.viewDidLoad()

        
        XCTAssertTrue(mockView.nameLabel.text == "dummy")
        expectation.fulfill()
    }
    
    // Shopping Cart View Controller (SCVC)
    func testSCVCUpdateWithProducts() {
        let expectation = XCTestExpectation(description: "Products stored successfully")

        let mockInteractor = ShoppingCartInteractor()
        let mockRouter = ShoppingCartRouter()
        let mockPresenter = ShoppingCartPresenter(router: mockRouter, interactor: mockInteractor)
        let mockView = ShoppingCartViewController(presenter: mockPresenter)
        
        
        let testSuggestedProduct = SuggestedProduct(id: "", imageURL: "", price: 0.0, name: "", priceText: "", shortDescription: "", category: "", unitPrice: 0.0, squareThumbnailURL: "", status: 0)
        let testSelectedProduct = Product.dummy
        mockPresenter.suggestedProducts.append(testSuggestedProduct)
        mockPresenter.selectedProductsArray.append((testSelectedProduct, 1))
        
        
        mockView.viewDidLoad()

        
        XCTAssertTrue(mockView.collectionView.numberOfItems(inSection: 0) == 1)
        XCTAssertTrue(mockView.collectionView.numberOfItems(inSection: 1) == 1)
        expectation.fulfill()
    }

}

