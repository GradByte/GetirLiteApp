//
//  Networking.swift
//  GetirLiteApp
//
//  Created by GradByte on 15.04.2024.
//

import Foundation
import Alamofire

struct NetworkingManager {
    static let shared = NetworkingManager()
    
    func fetchMainProducts(completion: @escaping ([MainProduct]?) -> Void) {
        AF.request("https://65c38b5339055e7482c12050.mockapi.io/api/products").responseDecodable(of: [MainProducts].self) { response in
            switch response.result {
            case .success(let mainProducts):
                completion(mainProducts.first?.products)
            case .failure(let error):
                print("Error fetching main products: \(error)")
                completion(nil)
            }
        }
    }
    
    func fetchSuggestedProducts(completion: @escaping ([SuggestedProduct]?) -> Void) {
        AF.request("https://65c38b5339055e7482c12050.mockapi.io/api/suggestedProducts").responseDecodable(of: [SuggestedProducts].self) { response in
            switch response.result {
            case .success(let suggestedProducts):
                completion(suggestedProducts.first?.products)
            case .failure(let error):
                print("Error fetching suggested products: \(error)")
                completion(nil)
            }
        }
    }
}
