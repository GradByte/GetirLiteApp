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
        let mockInteractor = ProductListingInteractor()
        let mockRouter = ProductListingRouter()
        let mockPresenter = ProductListingPresenter(router: mockRouter, interactor: mockInteractor)
        let view = ProductListingViewController(presenter: mockPresenter)
        mockInteractor.presenter = mockPresenter
        
        
        let testMainProduct = MainProduct(id: "", name: "", attribute: "", thumbnailURL: "", imageURL: "", price: 0.0, priceText: "", shortDescription: "")
        let testSugggestedProduct = SuggestedProduct(id: "", imageURL: "", price: 0.0, name: "", priceText: "", shortDescription: "", category: "", unitPrice: 0.0, squareThumbnailURL: "", status: 0)
        mockPresenter.mainProducts.append(testMainProduct)
        mockPresenter.suggestedProducts.append(testSugggestedProduct)
        
        
        view.viewDidLoad()

        
        XCTAssertTrue(view.collectionView.numberOfItems(inSection: 0) == 1)
        XCTAssertTrue(view.collectionView.numberOfItems(inSection: 1) == 1)
    }
    
    // Product Detail View Controller (PDVC)
    func testPDVCUpdateWithProducts() {
        let mockInteractor = ProductDetailInteractor()
        let mockRouter = ProductDetailRouter()
        let mockPresenter = ProductDetailPresenter(router: mockRouter, interactor: mockInteractor, product: Product.dummy)
        let view = ProductDetailViewController(presenter: mockPresenter)
        
        
        view.viewDidLoad()

        
        XCTAssertTrue(view.nameLabel.text == "dummy")
    }
    
    // Shopping Cart View Controller (SCVC)
    func testSCVCUpdateWithProducts() {
        let mockInteractor = ShoppingCartInteractor()
        let mockRouter = ShoppingCartRouter()
        let mockPresenter = ShoppingCartPresenter(router: mockRouter, interactor: mockInteractor)
        let view = ShoppingCartViewController(presenter: mockPresenter)
        
        
        let testSugggestedProduct = SuggestedProduct(id: "", imageURL: "", price: 0.0, name: "", priceText: "", shortDescription: "", category: "", unitPrice: 0.0, squareThumbnailURL: "", status: 0)
        mockPresenter.suggestedProducts.append(testSugggestedProduct)
        
        
        view.viewDidLoad()

        
        XCTAssertTrue(view.collectionView.numberOfItems(inSection: 1) == 1)
    }

}

