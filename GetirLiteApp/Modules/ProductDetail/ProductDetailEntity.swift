//
//  ProductDetailEntity.swift
//  GetirLiteApp
//
//  Created by GradByte on 17.04.2024.
//

import Foundation

protocol ProductProtocol {
    var id: String? { get }
    var imageURLString: String? { get }
    var name: String? { get }
    var price: Double? { get }
    var attributeString: String? { get }
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
