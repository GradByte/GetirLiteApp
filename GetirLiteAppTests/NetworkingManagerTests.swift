//
//  NetworkingManagerTests.swift
//  GetirLiteAppTests
//
//  Created by GradByte on 20.04.2024.
//

import XCTest
@testable import GetirLiteApp

final class NetworkingManagerTests: XCTestCase {

    var networkingManager: NetworkingManager!
        
        override func setUp() {
            super.setUp()
            networkingManager = NetworkingManager.shared
        }
        
        override func tearDown() {
            networkingManager = nil
            super.tearDown()
        }
        
        func testFetchMainProducts() {
            let expectation = self.expectation(description: "Fetching main products")
            
            networkingManager.fetchMainProducts { mainProducts in
                XCTAssertNotNil(mainProducts, "Main products should not be nil")
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 5, handler: nil)
        }
        
        func testFetchSuggestedProducts() {
            let expectation = self.expectation(description: "Fetching suggested products")
            
            networkingManager.fetchSuggestedProducts { suggestedProducts in
                XCTAssertNotNil(suggestedProducts, "Suggested products should not be nil")
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 5, handler: nil)
        }

}
