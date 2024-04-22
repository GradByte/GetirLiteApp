//
//  LocalData.swift
//  GetirLiteApp
//
//  Created by GradByte on 17.04.2024.
//

import Foundation
import CoreData
import UIKit

class LocalData {
    static let shared = LocalData()
    var selectedProducts = [Product:Int]()
    var totalBill: Double = 0.0
    
    func saveToCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let localDataEntity = LocalDataEntity(context: context)
        do {
            let jsonData = try JSONEncoder().encode(selectedProducts)
            let jsonString = String(data: jsonData, encoding: .utf8)
            localDataEntity.selectedProducts = jsonString
        } catch {
            print("Error encoding selectedProducts to JSON: \(error.localizedDescription)")
        }
        localDataEntity.totalBill = totalBill
        
        do {
            try context.save()
        } catch {
            print("Error saving LocalData to Core Data: \(error.localizedDescription)")
        }
    }
    
    func loadFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<LocalDataEntity> = LocalDataEntity.fetchRequest()
        
        do {
            let localDataEntities = try context.fetch(fetchRequest)
            if let localDataEntity = localDataEntities.last {
                if let jsonString = localDataEntity.selectedProducts {
                    if let jsonData = jsonString.data(using: .utf8) {
                        do {
                            let loadedData = try JSONDecoder().decode([Product: Int].self, from: jsonData)
                            self.selectedProducts = loadedData
                        } catch {
                            print("Error decoding selectedProducts from JSON: \(error.localizedDescription)")
                        }
                    }
                }
                self.totalBill = localDataEntity.totalBill
            }
        } catch {
            print("Error fetching LocalData from Core Data: \(error.localizedDescription)")
        }
    }

}
