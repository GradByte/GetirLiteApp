//
//  ProductListingEntity.swift
//  GetirLiteApp
//
//  Created by GradByte on 15.04.2024.
//

import Foundation

// MARK: - Product
struct MainProduct: Codable {
    let id, name: String?
    let productCount: Int?
    let products: [ProductElement]?
    let email, password: String?
}

// MARK: - ProductElement
struct ProductElement: Codable, Hashable {
    let id, name, attribute: String?
    let thumbnailURL, imageURL: String?
    let price: Double?
    let priceText, shortDescription: String?
}

typealias Products = [MainProduct]



// MARK: - SuggestedProduct
struct SuggestedProduct: Codable {
    let products: [Product]?
    let id, name: String?
}

// MARK: - Product
struct Product: Codable, Hashable {
    let id: String?
    let imageURL: String?
    let price: Double?
    let name, priceText, shortDescription, category: String?
    let unitPrice: Double?
    let squareThumbnailURL: String?
    let status: Int?
}

typealias SuggestedProducts = [SuggestedProduct]
