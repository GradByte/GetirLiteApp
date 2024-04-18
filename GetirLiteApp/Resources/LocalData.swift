//
//  LocalData.swift
//  GetirLiteApp
//
//  Created by GradByte on 17.04.2024.
//

import Foundation

class LocalData {
    static let shared = LocalData()
    
    var downloadedMainProducts = [MainProduct]()
    var downloadedSuggestedProducts = [SuggestedProduct]()
    
    var selectedProducts = [Product:Int]()
    
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
