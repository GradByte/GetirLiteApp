//
//  ProductListingEntity.swift
//  GetirLiteApp
//
//  Created by GradByte on 15.04.2024.
//

import Foundation

// MARK: - MainProducts
struct MainProducts: Codable {
    let id, name: String?
    let productCount: Int?
    let products: [MainProduct]?
    let email, password: String?
}
// MARK: - MainProduct
struct MainProduct: Codable, Hashable, ProductProtocol {
    let id, name, attribute: String?
    let thumbnailURL, imageURL: String?
    let price: Double?
    let priceText, shortDescription: String?
    
    // Implementing protocol properties for ProductProtocol
    var imageURLString: String? {
        return imageURL ?? thumbnailURL
    }
    
    var attributeString: String? {
        return attribute ?? shortDescription
    }
}



// MARK: - SuggestedProducts
struct SuggestedProducts: Codable {
    let products: [SuggestedProduct]?
    let id, name: String?
}
// MARK: - SuggestedProduct
struct SuggestedProduct: Codable, Hashable, ProductProtocol {
    let id: String?
    let imageURL: String?
    let price: Double?
    let name, priceText, shortDescription, category: String?
    let unitPrice: Double?
    let squareThumbnailURL: String?
    let status: Int?
    
    // Implementing protocol properties for ProductProtocol
    var imageURLString: String? {
        return imageURL ?? squareThumbnailURL
    }
    
    var attributeString: String? {
        return shortDescription
    }
}
