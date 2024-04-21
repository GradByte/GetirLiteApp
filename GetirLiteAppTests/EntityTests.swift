//
//  EntityTests.swift
//  GetirLiteAppTests
//
//  Created by GradByte on 21.04.2024.
//

import XCTest
@testable import GetirLiteApp

final class EntityTests: XCTestCase {

    func testSuggestedProduct() {
        let expectation = XCTestExpectation(description: "SuggestedProduct created successfully")

        let test = SuggestedProduct(id: "", imageURL: "", price: 0.0, name: "", priceText: "", shortDescription: "", category: "", unitPrice: 0.0, squareThumbnailURL: "", status: 0)
        
        XCTAssertEqual(test.id, "")
        XCTAssertEqual(test.imageURL, "")
        XCTAssertEqual(test.price, 0.0)
        XCTAssertEqual(test.name, "")
        XCTAssertEqual(test.priceText, "")
        XCTAssertEqual(test.shortDescription, "")
        XCTAssertEqual(test.category, "")
        XCTAssertEqual(test.unitPrice, 0.0)
        XCTAssertEqual(test.squareThumbnailURL, "")
        XCTAssertEqual(test.status, 0)
        expectation.fulfill()
    }
    
    func testMainProduct() {
        let expectation = XCTestExpectation(description: "MainProduct created successfully")

        let test = MainProduct(id: "", name: "", attribute: "", thumbnailURL: "", imageURL: "", price: 0.0, priceText: "", shortDescription: "")
        
        XCTAssertEqual(test.id, "")
        XCTAssertEqual(test.imageURL, "")
        XCTAssertEqual(test.price, 0.0)
        XCTAssertEqual(test.name, "")
        XCTAssertEqual(test.priceText, "")
        XCTAssertEqual(test.shortDescription, "")
        XCTAssertEqual(test.attribute, "")
        XCTAssertEqual(test.thumbnailURL, "")
        expectation.fulfill()
    }

}
