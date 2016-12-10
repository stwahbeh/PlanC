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
    
    let key: String
    let ref: FIRDatabaseReference?
    
    let model: [[String: Any]] = [
        ["Condoms": ["Qty": 0, "Price": 0]],
        ["Grapefruit": ["Qty": 0, "Price": 0]],
        ["Lube": ["Qty": 0, "Price": 0]],
    ]
    
    init(inventory: Int, price: Double, key: String = "") {
        self.key = key
        self.inventory = inventory
        self.price = price
        self.ref = nil
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
