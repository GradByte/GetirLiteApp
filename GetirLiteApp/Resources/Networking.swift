//
//  Networking.swift
//  GetirLiteApp
//
//  Created by GradByte on 15.04.2024.
//

import Foundation

struct NetworkingManager {
    static let shared = NetworkingManager()
    
    func fetchMainProducts() {
        
        guard let url = URL(string: "https://65c38b5339055e7482c12050.mockapi.io/api/products") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
                        
            do {
                let decoder = JSONDecoder()
                // Assuming your JSON response matches the structure you provided
                let products = try decoder.decode(Products.self, from: data)
                
                // Now you can access your data, such as:
                for product in products {
                    if let name = product.name {
                        print("Product Name: \(name)")
                    }
                    if let productCount = product.productCount {
                        print("Product Count: \(productCount)")
                    }
                    if let productElements = product.products {
                        for productElement in productElements {
                            if let name = productElement.name {
                                print("Sub-Product Name: \(name)")
                            }
                            if let price = productElement.price {
                                print("Price: \(price)")
                            }
                        }
                    }
                }
                
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        task.resume()
    }
    
    
    func fetchSuggestedProducts() {

        guard let url = URL(string: "https://65c38b5339055e7482c12050.mockapi.io/api/suggestedProducts") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let suggestedProducts = try decoder.decode(SuggestedProducts.self, from: data)
                
                // Now you can access your data, such as:
                for suggestedProduct in suggestedProducts {
                    if let name = suggestedProduct.name {
                        print("Suggested Product Name: \(name)")
                    }
                    if let products = suggestedProduct.products {
                        for product in products {
                            if let name = product.name {
                                print("Product Name: \(name)")
                            }
                            if let price = product.price {
                                print("Price: \(price)")
                            }
                        }
                    }
                }
                
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        task.resume()
    }
}
