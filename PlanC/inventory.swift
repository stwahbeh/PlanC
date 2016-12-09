//
//  inventory.swift
//  PlanC
//
//  Created by sam wahbeh on 12/8/16.
//  Copyright © 2016 PlanB. All rights reserved.
//

import Foundation

public struct Inventory {
    
    public var productName: String
    
    public var inventory: Int
    public var price: Double
    
    init(productName: String, inventory: Int, price: Double) {
        self.productName = productName
        
        self.inventory = inventory
        self.price = price
    }
    
    public func getProductName() -> String {
        return self.productName
    }
    
    
    
    public func getInventory() -> Int {
        return self.inventory
    }
    
    public func getPrice() -> Double {
        return self.price
    }
    
    public func toAnyObject() -> Any {
        return [
            "product name": self.productName,
            
            "inventory": self.inventory,
            "price": self.price
        ]
    }
}
