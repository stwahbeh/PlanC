//
//  inventory.swift
//  PlanC
//
//  Created by sam wahbeh on 12/8/16.
//  Copyright © 2016 PlanB. All rights reserved.
//

import Foundation
import Firebase

public struct Inventory {
    
    public var inventory: Int
    public var price: Double
    
    init(inventory: Int, price: Double) {
        self.inventory = inventory
        self.price = price
    }
    
    public func getInventory() -> Int {
        return self.inventory
    }
    
    public func getPrice() -> Double {
        return self.price
    }
    
    public func toAnyObject() -> Any {
        return [
            "inventory": self.inventory,
            "price": self.price
        ]
    }
}
