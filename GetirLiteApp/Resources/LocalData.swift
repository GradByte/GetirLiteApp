//
//  LocalData.swift
//  GetirLiteApp
//
//  Created by GradByte on 17.04.2024.
//

import Foundation

class LocalData {
    static let shared = LocalData()
    
    // IDs and count of selected products
    // var selectedProducts = [String: Int]()
    
    // Main products (vertical collection)
    var selectedMainProducts = [ProductElement:Int]()
    
    // Suggested products (horizontal collection)
    var selectedSuggestedProducts = [Product:Int]()
    
    // Total bill
    var totalBill: Double {
        didSet {
            // Notify observers that totalBill has changed
            NotificationCenter.default.post(name: Notification.Name("TotalBillUpdated"), object: nil)
        }
    }
    
    private init() {
        totalBill = 0.0
    }
}
