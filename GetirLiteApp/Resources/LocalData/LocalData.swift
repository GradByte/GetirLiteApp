//
//  LocalData.swift
//  GetirLiteApp
//
//  Created by GradByte on 17.04.2024.
//

import Foundation

class LocalData {
    static let shared = LocalData()
    var selectedProducts = [Product:Int]()
    var totalBill: Double = 0.0
}
