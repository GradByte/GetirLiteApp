//
//  Networking.swift
//  GetirLiteApp
//
//  Created by GradByte on 15.04.2024.
//

import Foundation

struct NetworkingManager {
    static let shared = NetworkingManager()
    
    func fetchMainProducts(completion: @escaping ([MainProduct]?) -> Void) {
        guard let url = URL(string: "https://65c38b5339055e7482c12050.mockapi.io/api/products") else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
                        
            do {
                let decoder = JSONDecoder()
                let products = try decoder.decode([MainProducts].self, from: data)
                completion(products[0].products)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    
    func fetchSuggestedProducts(completion: @escaping ([SuggestedProduct]?) -> Void) {

        guard let url = URL(string: "https://65c38b5339055e7482c12050.mockapi.io/api/suggestedProducts") else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let suggestedProducts = try decoder.decode([SuggestedProducts].self, from: data)
                completion(suggestedProducts[0].products)
                
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
}
