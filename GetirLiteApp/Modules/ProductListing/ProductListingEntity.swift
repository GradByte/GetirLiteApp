//
//  ProductListingEntity.swift
//  GetirLiteApp
//
//  Created by GradByte on 15.04.2024.
//

import Foundation

protocol ProductProtocol {
    var id: String? { get }
    var imageURLString: String? { get }
    var name: String? { get }
    var price: Double? { get }
    var attributeString: String? { get }
}

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
    
    // Implementing protocol properties
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
    
    // Implementing protocol properties
    var imageURLString: String? {
        return imageURL ?? squareThumbnailURL
    }
    
    var attributeString: String? {
        return shortDescription
    }
}


struct Product: ProductProtocol, Hashable {
    let id: String?
    let imageURLString: String?
    let name: String?
    let price: Double?
    let attributeString: String?
    
    init(mainProduct: MainProduct) {
        id = mainProduct.id
        imageURLString = mainProduct.imageURL
        name = mainProduct.name
        price = mainProduct.price
        attributeString = mainProduct.attribute
    }
    
    init(suggestedProduct: SuggestedProduct) {
        id = suggestedProduct.id
        imageURLString = suggestedProduct.imageURLString
        name = suggestedProduct.name
        price = suggestedProduct.price
        attributeString = suggestedProduct.attributeString
    }
    
    init() {
        id = "dummy"
        imageURLString = "dummy"
        name = "dummy"
        price = 0.0
        attributeString = "dummy"
    }
    
    static let dummy = Product()
}
