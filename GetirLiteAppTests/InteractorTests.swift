//
//  InteractorTests.swift
//  GetirLiteAppTests
//
//  Created by GradByte on 21.04.2024.
//

import XCTest
@testable import GetirLiteApp

final class InteractorTests: XCTestCase {

    // Product Listing Presenter (PLP)
    func testPLPUpdateWithProducts() {
        let expectation = XCTestExpectation(description: "Products fetched successfully")
        
        let mockInteractor = ProductListingInteractor()
        let mockRouter = ProductListingRouter()
        let mockPresenter = ProductListingPresenter(router: mockRouter, interactor: mockInteractor)
        
        mockInteractor.presenter = mockPresenter
        
        mockInteractor.fetchMainProducts()
        mockInteractor.fetchSuggestedProducts()
        
        // Wait for 3 seconds for the asynchronous calls to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertTrue(mockPresenter.mainProducts.count > 0)
            XCTAssertTrue(mockPresenter.suggestedProducts.count > 0)
            expectation.fulfill()
        }
    }
    
    // Shopping Cart Presenter (SCP)
    func testSCPUpdateWithProducts() {
        let expectation = XCTestExpectation(description: "Products fetched successfully")
        
        let mockInteractor = ShoppingCartInteractor()
        let mockRouter = ShoppingCartRouter()
        let mockPresenter = ShoppingCartPresenter(router: mockRouter, interactor: mockInteractor)
    
        mockInteractor.presenter = mockPresenter
        mockInteractor.fetchSelectedProducts()
        mockInteractor.fetchSuggestedProducts()

        // Wait for 3 seconds for the asynchronous calls to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertTrue(mockPresenter.selectedProductsArray.count > 0)
            XCTAssertTrue(mockPresenter.suggestedProducts.count > 0)
            expectation.fulfill()
        }
    }

}
